//
//  CustomTabView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/15.
//

import SwiftUI

struct CustomTabView: View {
	// MARK: -  PROPERTY
	@Binding var currentTab: String
	@Binding var showMenu: Bool
	@EnvironmentObject var vm : MapViewModel
	
	// MARK: -  BODY
	var body: some View {
		VStack {
			// Static Header View for all Pages..
			HStack {
				// Menu Button
				Button {
					// Toggleing Menu Option..
					withAnimation(.spring()) {
						showMenu = true
					}
				} label: {
					Image(systemName: "line.3.horizontal.decrease")
						.font(.title2.bold())
						.foregroundColor(.primary)
						.frame(width: 44, height: 44)
						.contentShape(Rectangle())
				}
				.accessibilityLabel("Open menu")
				// Hiding when Menu is Visible..
				.opacity(showMenu ? 0 : 1)
				Spacer()

				// Favorites toggle (Discover KR 탭에서만 표시)
				if currentTab == "Discover KR" {
					Button {
						withAnimation(.easeInOut) {
							vm.showFavoritesOnly.toggle()
						}
					} label: {
						Image(systemName: vm.showFavoritesOnly ? "heart.fill" : "heart")
							.font(.title3.bold())
							.foregroundColor(vm.showFavoritesOnly ? Color("AppPurple") : .primary)
							.frame(width: 44, height: 44)
							.contentShape(Rectangle())
					}
					.accessibilityLabel(vm.showFavoritesOnly ? "Show all places" : "Show favorites only")
				}

				// Show App Info Sheet
				Button {
					vm.isShowAppInfo = true
				} label: {
					Image(systemName: "info.circle")
						.font(.title3.bold())
						.foregroundColor(.primary)
						.frame(width: 44, height: 44)
						.contentShape(Rectangle())
				}
				.accessibilityLabel("App information")

			} //: HSTACK
			.overlay(
				Text(currentTab)
					.font(.title3.bold())
					.foregroundColor(.primary)
				// Same Hiding when Menu is Visible
					.opacity(showMenu ? 0 : 1)
			)
			.padding([.horizontal, .top])
			.padding(.bottom, 8)
			.padding(.top, getSafeArea().top)
			.sheet(isPresented: $vm.isShowAppInfo) {
				SettingView()
			}
		
			
			TabView(selection: $currentTab) {
				ContentView()
					.tag("Discover KR")
					.tabItem {
						Image(systemName: "house.fill")
						Text("Discover KR")
					}
				
				// Replace your Custom Views here..
				MapView()
					.tag("Map")
					.tabItem {
						Image(systemName: "safari.fill")
						Text("Map")
					}
								
				AboutView()
					.tag("Travel Info")
					.tabItem {
						Image(systemName: "info.circle.fill")
						Text("Travel Info")
					}

				PlannerView()
					.tag("Planner")
					.tabItem {
						Image(systemName: "calendar")
						Text("Planner")
					}
			} //: TAB
			.accentColor(Color("AppMint"))
		} //: VSTACK
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.overlay(
			// Close Button
			Button {
				// Toggleing Menu Option..
				withAnimation(.spring()) {
					showMenu = false
				}
			} label: {
				Image(systemName: "xmark")
					.font(.title.bold())
					.foregroundColor(.primary)
					.frame(width: 44, height: 44)
					.contentShape(Rectangle())
			}
			.accessibilityLabel("Close menu")
			// Hiding when Menu is Visible..
			.opacity(showMenu ? 1 : 0)
				.padding()
				.padding(.top)
			, alignment: .topLeading
		)
		.background(
			.ultraThinMaterial
		)
	}
}

// MARK: -  PREVIEW
struct CustomTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.environmentObject(MapViewModel())
			// .preferredColorScheme(.dark)
	}
}
