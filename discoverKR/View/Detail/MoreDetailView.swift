//
//  MoreDetailView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/01.
//

import SwiftUI
import MapKit

struct MoreDetailView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	@EnvironmentObject private var planner: PlannerViewModel
	let location: Location

	@StateObject private var guideVM = LocationGuideViewModel()
	@State private var showAddToPlan = false

	private var shareText: String {
		"\(location.name), \(location.cityName)\n\(location.headline)\n\n\(location.imageNames.first ?? "")"
	}

	// MARK: -  BODY
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 0) {
				heroSection

				VStack(alignment: .leading, spacing: 28) {
					headlineSection
					quickInfoSection
					highlightsSection
					if guideVM.hasAIContent { aiTipsSection }
					transportationSection
					mapSection
					contactSection
					addToPlanButton
					BannerAd(unitID: AdMobConfig.bannerUnitID)
					copyRight
				}
				.padding(.horizontal, 20)
				.padding(.top, 22)
				.padding(.bottom, 30)
			}
		}
		.ignoresSafeArea(edges: .top)
		.overlay(alignment: .topLeading) { backBtn }
		.overlay(alignment: .topTrailing) { topActions }
		.task { await guideVM.load(for: location) }
		.sheet(isPresented: $showAddToPlan) {
			AddToPlanSheet(location: location)
		}
	}
}

// MARK: -  SECTIONS
extension MoreDetailView {

	// HERO IMAGE + TITLE OVERLAY
	private var heroSection: some View {
		ZStack(alignment: .bottomLeading) {
			TabView {
				ForEach(location.imageNames, id: \.self) { imageName in
					RemoteImage(urlString: imageName, contentMode: .fill)
						.frame(width: UIScreen.main.bounds.width, height: 360)
						.clipped()
				}
			}
			.frame(height: 360)
			.tabViewStyle(.page(indexDisplayMode: .automatic))

			// Bottom gradient so the title stays readable
			LinearGradient(
				colors: [.clear, .black.opacity(0.15), .black.opacity(0.65)],
				startPoint: .top, endPoint: .bottom
			)
			.frame(height: 160)
			.frame(maxHeight: .infinity, alignment: .bottom)
			.allowsHitTesting(false)

			// Title overlay
			VStack(alignment: .leading, spacing: 6) {
				HStack(spacing: 6) {
					Image(systemName: "mappin.circle.fill")
						.foregroundColor(Color("AppMint"))
					Text(location.cityName)
						.font(.subheadline.weight(.semibold))
						.foregroundColor(.white.opacity(0.9))
				}
				Text(location.name)
					.font(.system(size: 30, weight: .bold))
					.foregroundColor(.white)
					.lineLimit(2)
			}
			.padding(20)
			.allowsHitTesting(false)
		}
		.frame(height: 360)
	}

	// HEADLINE + DESCRIPTION (AI overview when available, else JSON)
	private var headlineSection: some View {
		VStack(alignment: .leading, spacing: 14) {
			HStack {
				Text(location.headline)
					.font(.title3.weight(.semibold))
					.foregroundColor(Color("AppMint"))
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				if guideVM.hasAIContent { aiBadge }
			}

			switch guideVM.state {
			case .ready(let guide):
				Text(guide.overview)
					.font(.callout)
					.foregroundColor(.secondary)
					.lineSpacing(4)
					.fixedSize(horizontal: false, vertical: true)
					.transition(.opacity)
			case .loading:
				VStack(alignment: .leading, spacing: 10) {
					HStack(spacing: 8) {
						ProgressView().controlSize(.small)
						Text("Creating your AI guide…")
							.font(.caption)
							.foregroundColor(.secondary)
					}
					Text(location.description)
						.font(.callout)
						.foregroundColor(.secondary.opacity(0.6))
						.lineSpacing(4)
						.fixedSize(horizontal: false, vertical: true)
				}
			case .unavailable, .failed:
				Text(location.description)
					.font(.callout)
					.foregroundColor(.secondary)
					.lineSpacing(4)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.animation(.easeInOut(duration: 0.25), value: guideVM.hasAIContent)
	}

	// AI badge chip
	private var aiBadge: some View {
		HStack(spacing: 4) {
			Image(systemName: "sparkles")
			Text("AI")
				.fontWeight(.bold)
		}
		.font(.caption2)
		.foregroundColor(Color("AppPurple"))
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background(Color("AppPurple").opacity(0.12))
		.clipShape(Capsule())
	}

	// QUICK INFO CARD (hours / fee / parking)
	private var quickInfoSection: some View {
		VStack(spacing: 0) {
			if !location.availableHours.isEmpty {
				infoRow(icon: "clock.fill", title: "Hours", value: location.availableHours)
			}
			if !location.fee.isEmpty {
				if !location.availableHours.isEmpty { divider }
				infoRow(icon: "ticket.fill", title: "Admission", value: location.fee)
			}
			if !location.parking.isEmpty {
				if !location.availableHours.isEmpty || !location.fee.isEmpty { divider }
				infoRow(icon: "car.fill", title: "Parking", value: location.parking)
			}
		}
		.padding(.vertical, 4)
		.background(.ultraThinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.overlay(
			RoundedRectangle(cornerRadius: 16)
				.stroke(Color.primary.opacity(0.06), lineWidth: 1)
		)
	}

	// HIGHLIGHTS (AI list when ready, else JSON Don't Miss carousel)
	@ViewBuilder
	private var highlightsSection: some View {
		if case .ready(let guide) = guideVM.state, !guide.highlights.isEmpty {
			VStack(alignment: .leading, spacing: 12) {
				HStack {
					sectionHeader(icon: "star.fill", text: "Highlights")
					Spacer()
					aiBadge
				}
				VStack(alignment: .leading, spacing: 10) {
					ForEach(guide.highlights, id: \.self) { item in
						HStack(alignment: .top, spacing: 10) {
							Image(systemName: "checkmark.circle.fill")
								.foregroundColor(Color("AppMint"))
								.font(.subheadline)
							Text(item)
								.font(.callout)
								.foregroundColor(.primary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
				}
			}
		} else if !location.donMiss.isEmpty {
			VStack(alignment: .leading, spacing: 8) {
				sectionHeader(icon: "star.fill", text: "Don't Miss")
				InsetDontMissView(location: location)
			}
		}
	}

	// AI-ONLY: travel tip + best time to visit
	@ViewBuilder
	private var aiTipsSection: some View {
		if case .ready(let guide) = guideVM.state {
			VStack(alignment: .leading, spacing: 12) {
				HStack {
					sectionHeader(icon: "lightbulb.fill", text: "Travel Tips")
					Spacer()
					aiBadge
				}
				VStack(spacing: 0) {
					if !guide.travelTip.isEmpty {
						infoRow(icon: "hand.thumbsup.fill", title: "Insider Tip", value: guide.travelTip)
					}
					if !guide.bestTimeToVisit.isEmpty {
						if !guide.travelTip.isEmpty { divider }
						infoRow(icon: "calendar", title: "Best Time to Visit", value: guide.bestTimeToVisit)
					}
				}
				.padding(.vertical, 4)
				.background(Color("AppPurple").opacity(0.06))
				.clipShape(RoundedRectangle(cornerRadius: 16))
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color("AppPurple").opacity(0.15), lineWidth: 1)
				)
			}
		}
	}

	// TRANSPORTATION
	private var transportationSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			sectionHeader(icon: "tram.fill", text: "Getting There")
			Text(location.transportation)
				.font(.callout)
				.foregroundColor(.secondary)
				.lineSpacing(4)
				.fixedSize(horizontal: false, vertical: true)
		}
	}

	// MAP CARD
	private var mapSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			sectionHeader(icon: "map.fill", text: "Location")

			ZStack(alignment: .bottomTrailing) {
				Map(coordinateRegion: .constant(MKCoordinateRegion(
					center: location.coordinates,
					span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
					annotationItems: [location]) { loc in
					MapAnnotation(coordinate: loc.coordinates) {
						MapAnnotationPin().shadow(radius: 6)
					}
				}
				.allowsHitTesting(false)
				.frame(height: 200)

				// Open in Apple Maps
				Button(action: openInMaps) {
					HStack(spacing: 6) {
						Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
						Text("Directions")
							.fontWeight(.semibold)
					}
					.font(.footnote)
					.foregroundColor(.white)
					.padding(.horizontal, 14)
					.padding(.vertical, 9)
					.background(Color("AppMint"))
					.clipShape(Capsule())
					.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
				}
				.accessibilityLabel("Get directions in Maps")
				.padding(12)
			}
			.clipShape(RoundedRectangle(cornerRadius: 16))

			if !location.address.isEmpty {
				HStack(alignment: .top, spacing: 8) {
					Image(systemName: "mappin.and.ellipse")
						.foregroundColor(Color("AppMint"))
						.font(.footnote)
					Text(location.address)
						.font(.footnote)
						.foregroundColor(.secondary)
				}
				.padding(.top, 2)
			}
		}
	}

	// CONTACT (phone + website)
	private var contactSection: some View {
		VStack(alignment: .leading, spacing: 0) {
			sectionHeader(icon: "info.circle.fill", text: "Information")
				.padding(.bottom, 8)

			VStack(spacing: 0) {
				if !location.phone.isEmpty {
					contactRow(icon: "phone.fill", label: location.phone,
							   url: "tel://\(location.phone.filter { $0.isNumber })")
				}
				if !location.link.isEmpty {
					if !location.phone.isEmpty { divider }
					contactRow(icon: "globe", label: "Visit Website", url: location.link)
				}
			}
			.padding(.vertical, 4)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 16))
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.primary.opacity(0.06), lineWidth: 1)
			)
		}
	}

	// ADD TO PLAN BUTTON
	private var addToPlanButton: some View {
		Button {
			showAddToPlan = true
		} label: {
			HStack {
				Image(systemName: "calendar.badge.plus")
					.font(.title3)
				Text("Add to Trip Plan")
					.font(.headline)
			}
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.padding()
			.background(Color("AppPurple"))
			.clipShape(RoundedRectangle(cornerRadius: 14))
			.shadow(color: Color("AppPurple").opacity(0.35), radius: 8, x: 0, y: 4)
		}
	}

	// COPYRIGHT
	private var copyRight: some View {
		Text(location.copyright)
			.font(.caption2)
			.foregroundColor(.secondary.opacity(0.7))
			.multilineTextAlignment(.center)
			.frame(maxWidth: .infinity)
			.padding(.top, 8)
	}
}

// MARK: -  FLOATING BUTTONS
extension MoreDetailView {

	private var backBtn: some View {
		Button {
			vm.sheetLocation = nil
		} label: {
			Image(systemName: "chevron.left")
				.floatingIcon()
		}
		.accessibilityLabel("Close")
		.padding(.leading, 16)
		.padding(.top, 8)
	}

	private var topActions: some View {
		HStack(spacing: 10) {
			ShareLink(item: shareText) {
				Image(systemName: "square.and.arrow.up")
					.floatingIcon()
			}
			FavoriteButton(location: location)
				.floatingIcon()
		}
		.padding(.trailing, 16)
		.padding(.top, 8)
	}
}

// MARK: -  HELPERS
extension MoreDetailView {

	private var divider: some View {
		Divider().padding(.leading, 52)
	}

	private func sectionHeader(icon: String, text: String) -> some View {
		HStack(spacing: 8) {
			Image(systemName: icon)
				.foregroundColor(Color("AppMint"))
				.font(.subheadline)
			Text(text)
				.font(.title3.bold())
				.foregroundColor(.primary)
		}
	}

	private func infoRow(icon: String, title: String, value: String) -> some View {
		HStack(alignment: .top, spacing: 14) {
			Image(systemName: icon)
				.font(.subheadline)
				.foregroundColor(Color("AppMint"))
				.frame(width: 24, height: 24)
				.padding(.top, 2)
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.caption)
					.foregroundColor(.secondary)
				Text(value)
					.font(.subheadline.weight(.medium))
					.foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
			}
			Spacer(minLength: 0)
		}
		.padding(.horizontal, 14)
		.padding(.vertical, 12)
	}

	private func contactRow(icon: String, label: String, url: String) -> some View {
		Link(destination: URL(string: url) ?? URL(string: "https://english.visitkorea.or.kr")!) {
			HStack(spacing: 14) {
				Image(systemName: icon)
					.font(.subheadline)
					.foregroundColor(Color("AppMint"))
					.frame(width: 24, height: 24)
				Text(label)
					.font(.subheadline.weight(.medium))
					.foregroundColor(.primary)
				Spacer()
				Image(systemName: "chevron.right")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			.padding(.horizontal, 14)
			.padding(.vertical, 14)
		}
	}

	private func openInMaps() {
		let placemark = MKPlacemark(coordinate: location.coordinates)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = location.name
		mapItem.openInMaps(launchOptions: [
			MKLaunchOptionsMapTypeKey: NSNumber(value: MKMapType.standard.rawValue)
		])
	}
}

// MARK: -  FLOATING ICON STYLE
private extension View {
	func floatingIcon() -> some View {
		self
			.font(.headline)
			.foregroundColor(.primary)
			.frame(width: 44, height: 44)
			.background(.thinMaterial)
			.clipShape(Circle())
			.shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
	}
}

// MARK: -  PREVIEW
struct MoreDetailView_Previews: PreviewProvider {
	static let locations: [Location] = Bundle.main.decode("discoverDB.json")

	static var previews: some View {
		MoreDetailView(location: locations[0])
			.environmentObject(MapViewModel())
			.environmentObject(PlannerViewModel())
	}
}
