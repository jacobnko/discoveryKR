//
//  BannerAd.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//


import SwiftUI
import GoogleMobileAds

/// SwiftUI banner ad that uses an **adaptive anchored** size (fills the device
/// width) and keeps vertical breathing room so it never sits flush against
/// tappable content (AdMob accidental-click policy).
struct BannerAd: View {
	let unitID: String

	private var adSize: GADAdSize {
		GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(getReact().width)
	}

	var body: some View {
		if AdMobConfig.adsHidden {
			// 스크린샷 모드: 배너 영역 자체를 숨김
			Color.clear.frame(height: 0)
		} else {
			BannerAdRepresentable(unitID: unitID, adSize: adSize)
				.frame(height: adSize.size.height)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 8) // separation from tappable content
				.accessibilityLabel("Advertisement")
		}
	}
}

// MARK: - UIViewRepresentable
private struct BannerAdRepresentable: UIViewRepresentable {

	let unitID: String
	let adSize: GADAdSize

	func makeCoordinator() -> Coordinator {
		// For Implementing Delegates..
		return Coordinator()
	}

	func makeUIView(context: Context) -> GADBannerView {
		let adView = GADBannerView(adSize: adSize)

		adView.adUnitID = unitID
		adView.rootViewController = UIApplication.shared.getRootViewController()
		adView.delegate = context.coordinator
		adView.load(GADRequest())

		return adView
	}

	func updateUIView(_ uiView: GADBannerView, context: Context) {

	}

	class Coordinator: NSObject, GADBannerViewDelegate {
		
	
		func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
			// print("bannerViewDidReceiveAd")
		}

		func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
			// print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
		}

		func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
			// print("bannerViewDidRecordImpression")
		}

		func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
			// print("bannerViewWillPresentScreen")
		}

		func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
			// print("bannerViewWillDIsmissScreen")
		}

		func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
			// print("bannerViewDidDismissScreen")
		}
	}
}

// Extending Application to get RootView..
extension UIApplication {
	func getRootViewController() -> UIViewController {
		
		guard let screen = self.connectedScenes.first as? UIWindowScene else {
			return .init()
		}
		
		guard let root = screen.windows.first?.rootViewController else {
			return .init()
		}
		
		return root
	}
}
