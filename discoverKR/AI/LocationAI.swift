//
//  LocationAI.swift
//  DiscoverKR
//
//  On-device AI travel guide powered by Apple Foundation Models (iOS 26).
//  Uses the existing JSON Location data as grounding input — no external tools.
//  Falls back to the raw JSON content on devices without Apple Intelligence.
//

import SwiftUI
import FoundationModels

// MARK: -  GENERATED OUTPUT

/// Structured AI output generated from a `Location`'s existing JSON fields.
/// `Codable` so guides can be persisted to disk and reused across launches.
@Generable
struct AILocationGuide: Codable {
	@Guide(description: "An engaging 2 to 3 sentence overview that makes an international traveler excited to visit. Warm, vivid, factual.")
	var overview: String

	@Guide(description: "Three to five specific must-see highlights or things to do here. Each item is a short phrase, under 12 words, no numbering.")
	var highlights: [String]

	@Guide(description: "One practical insider travel tip for visiting this place.")
	var travelTip: String

	@Guide(description: "The best time of day or season to visit and a brief reason, in one short sentence.")
	var bestTimeToVisit: String
}

// MARK: -  SERVICE

/// Generates and caches AI guides. All access is main-actor isolated.
@MainActor
final class LocationAIService {
	static let shared = LocationAIService()
	private init() { loadDiskCache() }

	private var cache: [String: AILocationGuide] = [:]

	/// Bump to invalidate all persisted guides (e.g. when the prompt changes).
	private let cacheVersion = 1
	private var cacheFileURL: URL {
		let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		return dir.appendingPathComponent("ai_guides_v\(cacheVersion).json")
	}

	/// Whether the on-device model can run on this device right now.
	var isAvailable: Bool {
		if case .available = SystemLanguageModel.default.availability { return true }
		return false
	}

	func cachedGuide(for id: String) -> AILocationGuide? { cache[id] }

	/// Generate (or return cached) AI guide for a location.
	func generateGuide(for location: Location) async throws -> AILocationGuide {
		if let cached = cache[location.id] { return cached }

		let session = LanguageModelSession(instructions: """
		You are a knowledgeable Korea travel guide writing for international tourists.
		Base everything ONLY on the factual details given about the place.
		Do not invent prices, addresses, phone numbers, or historical claims that are
		not implied by the input. Write in clear, friendly English.
		""")

		let prompt = """
		Create a short travel guide for this place in Korea using the details below.

		Name: \(location.name)
		City / Region: \(location.cityName)
		Tagline: \(location.headline)
		Description: \(location.description)
		Notable points: \(location.donMiss.joined(separator: "; "))
		Getting there: \(location.transportation)
		"""

		let response = try await session.respond(to: prompt, generating: AILocationGuide.self)
		cache[location.id] = response.content
		saveDiskCache()
		return response.content
	}

	// MARK: Disk persistence

	private func loadDiskCache() {
		guard let data = try? Data(contentsOf: cacheFileURL),
			  let decoded = try? JSONDecoder().decode([String: AILocationGuide].self, from: data)
		else { return }
		cache = decoded
	}

	private func saveDiskCache() {
		guard let data = try? JSONEncoder().encode(cache) else { return }
		try? data.write(to: cacheFileURL, options: .atomic)
	}
}

// MARK: -  VIEW MODEL

/// Drives the AI section of the detail screen with graceful JSON fallback.
@MainActor
final class LocationGuideViewModel: ObservableObject {

	enum State {
		case unavailable          // device can't run AI → UI uses JSON
		case loading
		case ready(AILocationGuide)
		case failed               // generation error → UI uses JSON
	}

	@Published var state: State = .loading

	/// True when AI content should be shown; otherwise the view uses JSON data.
	var hasAIContent: Bool {
		if case .ready = state { return true }
		return false
	}

	func load(for location: Location) async {
		// Don't regenerate if we already have content for this view.
		if case .ready = state { return }

		// 1. Cached guide (memory or disk) → show instantly, even offline.
		if let cached = LocationAIService.shared.cachedGuide(for: location.id) {
			state = .ready(cached)
			return
		}

		// 2. No cache → we need the on-device model.
		guard LocationAIService.shared.isAvailable else {
			state = .unavailable
			return
		}

		state = .loading
		do {
			let guide = try await LocationAIService.shared.generateGuide(for: location)
			state = .ready(guide)
		} catch {
			state = .failed
		}
	}
}
