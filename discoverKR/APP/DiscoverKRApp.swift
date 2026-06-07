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
			.onChange(of: showSplashScreen) { _, isShowing in
				// 스플래시가 사라지고 메인 화면이 보인 뒤 ATT 권한 요청 (검은 배경 위 X)
				guard !isShowing else { return }
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
					AdMobConfig.requestTrackingAuthorization()
				}
			}
		}
	}
}
