//
//  AdMobConfig.swift
//  DiscoverKR
//
//  Central place for all AdMob identifiers + App Tracking Transparency.
//  DEBUG builds use Google's official TEST ad units so you never click your
//  own live ads during development. RELEASE builds use the real production IDs.
//

import Foundation
import AppTrackingTransparency
import GoogleMobileAds

enum AdMobConfig {

	// MARK: - Banner Ad Unit ID

	/// Google official TEST banner unit — safe to use while developing.
	private static let testBannerUnitID = "ca-app-pub-3940256099942544/2934735716"

	/// DiscoverKR 실제 Banner Ad Unit ID (Discovery_Banner)
	private static let prodBannerUnitID = "ca-app-pub-8787171365157933/4677339110"

	/// Banner unit id resolved per build configuration.
	static var bannerUnitID: String {
		#if DEBUG
		return testBannerUnitID
		#else
		return prodBannerUnitID
		#endif
	}

	// MARK: - App Tracking Transparency

	/// Requests ATT authorization. Safe to call multiple times — the system
	/// only shows the prompt once, afterwards it returns the stored status.
	/// Call when the app is active (not during `init`).
	static func requestTrackingAuthorization() {
		ATTrackingManager.requestTrackingAuthorization { _ in }
	}
}
