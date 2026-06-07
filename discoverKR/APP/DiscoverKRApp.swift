//
//  DiscoverKRApp.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI
import GoogleMobileAds

@main
struct DiscoverKRApp: App {

	@StateObject private var vm: MapViewModel = MapViewModel()
	@StateObject private var planner: PlannerViewModel = PlannerViewModel()
	@State private var showSplashScreen: Bool = true

	init() {
		GADMobileAds.sharedInstance().start(completionHandler: nil)
	}

	var body: some Scene {
		WindowGroup {
			ZStack {
				// Main 앱 (스플래시 뒤에서 미리 로딩)
				MainView()
					.environmentObject(vm)
					.environmentObject(planner)

				// 스플래시 - 완전히 덮어씌움
				if showSplashScreen {
					SplashScreen(showSplashScreen: $showSplashScreen)
						.zIndex(1)
				}
			}
			.task {
				// ATT 권한 요청은 앱이 active 된 직후에 (init 단계 X)
				try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
				AdMobConfig.requestTrackingAuthorization()
			}
		}
	}
}
