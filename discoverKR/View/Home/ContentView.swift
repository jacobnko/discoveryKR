//
//  ContentView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct ContentView: View {
	// MARK: -  PROPERTY
	
	@EnvironmentObject private var vm: MapViewModel
	@Namespace var animation
	@Environment(\.colorScheme) var scheme
	
	// MARK: -  BODY
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				VStack {
					searchBar
						.padding(.top)
					if vm.searchText.isEmpty {
						categoryView
					}
					if !vm.searchText.isEmpty {
						searchResultsView
					} else if vm.showFavoritesOnly {
						favoritesScrollView
					} else {
						bodyView
					}
				} //: VSTACK
			} //: VSTACK
			.padding([.horizontal, .top])
		} //: ZSTACK
		.background(.ultraThickMaterial)
		.sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
			MoreDetailView(location: location)
		}
	}
}

// MARK: -  EXTENSTION
extension ContentView {
	// Header
	// private var header: some View {
	// 	HStack (spacing: 50) {
	//
	// 		Button {
	//
	// 		} label: {
	// 			Image(systemName: "list.dash").font(.title2)
	// 		}
	//
	// 		Text("awesome kr".uppercased())
	// 			.font(.title)
	// 			.fontWeight(.heavy)
	// 			.hLeading()
	//
	// 	} //: HSTACK
	// 	.foregroundColor(.primary)
	// 	.padding(.horizontal)
	// }
	
	// categoryView
	private var categoryView: some View {
		// Scroll View Reader..
		// to scroll tab automatically when user scrolls..
		ScrollViewReader { proxy in
			
			ScrollView(.horizontal, showsIndicators: false) {
				HStack (spacing: 16) {

					ForEach(vm.tabItems) { tab in
						LazyVStack {
							
							Text(tab.tab)
								.foregroundColor(vm.currentTab.replacingOccurrences(of: " SCROLL", with: "") == tab.id ? .primary : .gray)
								.fontWeight(.bold)
							
							// For matched geometry effect..
							if vm.currentTab.replacingOccurrences(of: " SCROLL", with: "") == tab.id {
								Capsule()
									.fill(Color("AppMint"))
									.matchedGeometryEffect(id: "TAB", in: animation)
									.frame(height: 3)
									.padding(.horizontal, -10)
							} else {
								Capsule()
									.fill(.clear)
									.frame(height: 3)
									.padding(.horizontal, -10)
							}
							
						} //: VSTACK
						.onTapGesture {
							withAnimation(.easeInOut) {
								vm.currentTab = "\(tab.id) TAP"
								proxy.scrollTo(vm.currentTab.replacingOccurrences(of: " TAP", with: ""), anchor: .topTrailing)
							}
						}
					} //: LOOP
				} //: HSTACK
				.padding(.horizontal)
				.background(.ultraThinMaterial)
			} //: SCROLL
			.onChange(of: vm.currentTab, perform: { _ in
				// Enabling scrolling..
				if vm.currentTab.contains(" SCROLL") {
					withAnimation(.easeInOut) {
						proxy.scrollTo(vm.currentTab.replacingOccurrences(of: " SCROLL", with: ""), anchor: .topTrailing)
					}
				}
			})
			.background(scheme == .dark ? Color.black : Color.white)
			.overlay(
				Divider()
					.padding(.horizontal, -15)
				, alignment: .bottom
			)
		} //: SCROLLREADER
		// Setting first tab..
		.onAppear {
			vm.currentTab = vm.tabItems.first?.id ?? ""
		}
	}
	
	
	// bodyView
	private var bodyView: some View {
		// Scrool view reader to scroll the content..
		ScrollView(.vertical, showsIndicators: false) {
			
			ScrollViewReader { proxy in
				LazyVStack (spacing: 15) {
					BannerAd(unitID: AdMobConfig.bannerUnitID)
					ForEach(vm.tabItems) { tab in
						// Location Card Item
						LocationCardView(tab: tab, currentTab: $vm.currentTab)
					}
					
				} //: VSTACK
				.padding([.bottom])
				.onChange(of: vm.currentTab) { newValue in
					// avoid scroll if its tap..
					if vm.currentTab.contains(" TAP") {
						// Scrolling to content..
						withAnimation(.easeInOut) {
							proxy.scrollTo(vm.currentTab.replacingOccurrences(of: " TAP", with: ""), anchor: .topTrailing)
						}
					}
				}
			} //: SCROLLREADER
		} //: SCROLL
		// Setting Coordinate Space name for offset..
		.coordinateSpace(name: "SCROLL")
	}

	// SEARCH BAR
	private var searchBar: some View {
		HStack(spacing: 8) {
			Image(systemName: "magnifyingglass")
				.foregroundColor(.gray)
			TextField("Search places, cities...", text: $vm.searchText)
				.autocorrectionDisabled()
			if !vm.searchText.isEmpty {
				Button {
					vm.searchText = ""
				} label: {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.gray)
				}
			}
		}
		.padding(10)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
	}

	// SEARCH RESULTS VIEW
	private var searchResultsView: some View {
		ScrollView(.vertical, showsIndicators: false) {
			LazyVStack(spacing: 12) {
				if vm.searchResults.isEmpty {
					VStack(spacing: 16) {
						Image(systemName: "magnifyingglass")
							.font(.system(size: 48))
							.foregroundColor(.gray.opacity(0.4))
						Text("No results for \"\(vm.searchText)\"")
							.font(.headline)
							.foregroundColor(.secondary)
					}
					.padding(.top, 80)
				} else {
					ForEach(vm.searchResults) { location in
						Button {
							vm.sheetLocation = location
						} label: {
							locationRowView(location: location)
						}
					}
				}
			}
			.padding(.vertical)
		}
	}

	// FAVORITES VIEW
	private var favoritesScrollView: some View {
		ScrollView(.vertical, showsIndicators: false) {
			LazyVStack(spacing: 12) {
				if vm.favoriteLocations.isEmpty {
					VStack(spacing: 16) {
						Image(systemName: "heart.slash")
							.font(.system(size: 48))
							.foregroundColor(.gray.opacity(0.4))
						Text("No saved places yet")
							.font(.headline)
							.foregroundColor(.secondary)
						Text("Tap ♥ on any place to save it")
							.font(.subheadline)
							.foregroundColor(.secondary)
					}
					.padding(.top, 80)
				} else {
					ForEach(vm.favoriteLocations) { location in
						Button {
							vm.sheetLocation = location
						} label: {
							locationRowView(location: location)
						}
					}
				}
			}
			.padding(.vertical)
		}
	}

	// SHARED ROW VIEW (search & favorites)
	private func locationRowView(location: Location) -> some View {
		HStack(spacing: 12) {
			RemoteImage(urlString: location.imageNames.first ?? "", cornerRadius: 10)
				.frame(width: 70, height: 70)
				.clipShape(RoundedRectangle(cornerRadius: 10))

			VStack(alignment: .leading, spacing: 4) {
				Text(location.name)
					.font(.headline)
					.foregroundColor(Color("AppPurple"))
				Text(location.cityName)
					.font(.subheadline)
					.foregroundColor(.secondary)
				Text(location.headline)
					.font(.caption)
					.foregroundColor(.secondary)
					.lineLimit(2)
			}
			Spacer()
			FavoriteButton(location: location)
				.padding(.trailing, 4)
		}
		.padding(12)
		.frame(maxWidth: .infinity)
		.background(.ultraThickMaterial)
		.cornerRadius(12)
		.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
	}
}


// MARK: -  PREVIEW
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(MapViewModel())
			.preferredColorScheme(.dark)
	}
}


// MARK: -  LocationCardView

struct LocationCardView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	let tab: Tab
	@Binding var currentTab: String
	
	// MARK: -  BODY
	var body: some View {
		LazyVStack(alignment: .leading, spacing: 20) {
			Text(tab.tab)
				.font(.title.bold())
				.padding([.horizontal, .top])
			
			ForEach(tab.locations) { location in
				Button {
					vm.sheetLocation = location
				} label: {
					HStack(alignment: .center, spacing: 16) {
						
						RemoteImage(urlString: location.imageNames[0], cornerRadius: 12)
							.frame(width: 80, height: 80)
							.clipped()
							.padding(10)
						
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Text(location.name)
									.font(.title2)
									.fontWeight(.bold)
									.foregroundColor(Color("AppPurple"))
								Spacer()
								FavoriteButton(location: location)
									.padding(.trailing, 5)
							} //: HSTACK
							
							Text(location.headline)
								.font(.footnote)
								.foregroundColor(.primary)
								.multilineTextAlignment(.leading)
								.lineLimit(2)
								.padding(.trailing, 8)
						} //: VSTACK
						.hLeading()
					} //: HSTACK
					.frame(width: UIScreen.main.bounds.width * 0.9)
					.background(.ultraThickMaterial)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
				}
			} //: LOOP
		} //: VSTACK
		.modifier(OffsetModifier(tab: tab, currentTab: $currentTab))
		.id(tab.id)
	}
}
