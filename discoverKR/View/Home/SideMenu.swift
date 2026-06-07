//
//  SideMenu.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/15.
//

import SwiftUI

struct SideMenu: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	@Binding var currentDrawerTab: String
	// Adding Smooth Transition between tabs with the help of matched Geometry Effects..
	@Namespace var animation
	@Environment(\.colorScheme) var scheme
	
	// MARK: -  BODY
	var body: some View {
		VStack {
			// title 부분
			HStack (spacing: 15) {
				// 여기 AWESOME KR 로고 들어갈 자리
				// Image("Pic")
				// 	.resizable()
				// 	.aspectRatio(contentMode: .fill)
				// 	.frame(width: 45, height: 45)
				// 	.clipShape(Circle())
				
				Text("Welcome\nDiscover KR")
					.font(.title2.bold())
					.foregroundColor(.white)
			} //: HSTACK
			.padding()
			.hLeading()
			
			// For smaal Screens to add ScrollView Buttons
			ScrollView(.vertical, showsIndicators: false) {
				// Tab Buttons..
				VStack(alignment: .leading, spacing: 30) {
					
					CustomTabButton(icon: "house.fill", title: "Discover KR")
					CustomTabButton(icon: "safari.fill", title: "Map")
					CustomTabButton(icon: "info.circle.fill", title: "Travel Info")
					CustomTabButton(icon: "calendar", title: "Planner")
					
					Spacer()
					
					Text("App Version: 2.0\n©Jacob Taehun Ko")
						.font(.footnote)
						.foregroundColor(.white)

				} //: VSTACK
				.padding()
				.padding(.top, 40)
				// Max Width of screen width
				.frame(width: getReact().width / 2, height: getReact().height * 0.8, alignment: .leading)
				.hLeading()
			}
		} //: VSTACK
		.padding(.leading, 10)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background(
			Color("AppPurple")
		)
	}
	
	// Custom Button
	@ViewBuilder
	func CustomTabButton(icon: String, title: String) -> some View {
		Button {
			withAnimation(.spring()) {
				currentDrawerTab = title
			}
		} label: {
			HStack (spacing: 12) {
				Image(systemName: icon)
					.font(.title3)
					.frame(width: currentDrawerTab == title ? 48 : nil, height: 48)
					.foregroundColor(
						currentDrawerTab == title ? Color("AppPurple") : Color.white)
					.background(
						ZStack {
							if currentDrawerTab == title {
								Color.white
									.clipShape(Circle())
									.matchedGeometryEffect(id: "TABCIRCLE", in: animation)
							}
						} //: ZSTACK
					)
				
				Text(title)
					.font(.callout)
					.fontWeight(.semibold)
					.foregroundColor(.white)
			} //: HSTACK
			.padding(.trailing, 18)
			.background(
				ZStack {
					if currentDrawerTab == title {
						Color("AppMint")
							.clipShape(Capsule())
							.matchedGeometryEffect(id: "TABCAPSULE", in: animation)
					}
				} //: ZSTACK
			)
		}
		.offset(x: currentDrawerTab == title ? 15 : 0)
	}
}

// MARK: -  PREVIEW
struct SideMenu_Previews: PreviewProvider {
	
	static var previews: some View {
		MainView()
			.environmentObject(MapViewModel())
			.preferredColorScheme(.dark)
	}
}


