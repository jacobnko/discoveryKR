//
//  MainView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct MainView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	// AdMob SDK는 DiscoverKRApp.init에서 한 번만 start (중복 호출 제거)

	// MARK: -  BODY
	var body: some View {
		ZStack {
			// Custom Slide menu
			SideMenu(currentDrawerTab: $vm.currentDrawerTab)
			
			// Main tab View..
			CustomTabView(currentTab: $vm.currentDrawerTab, showMenu: $vm.showMenu)
			// Appling Corner Radius
				.cornerRadius(vm.showMenu ? 25 : 0)
			// Mading 3D rotation
				.rotation3DEffect(.init(degrees: vm.showMenu ? -15 : 0), axis: (x: 0, y: 1, z: 0), anchor: .trailing)
			// Moving View Apart..
				.offset(x: vm.showMenu ? getReact().width / 2 : 0)
				.ignoresSafeArea()
		} //: ZSTACK
		.background(
			.ultraThickMaterial
		)
		.favoriteToast()
	}
}

// MARK: -  PREVIEW
struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.environmentObject(MapViewModel())
	}
}
