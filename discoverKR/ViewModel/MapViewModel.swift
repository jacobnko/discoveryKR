//
//  MapViewModel.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI
import MapKit


class MapViewModel: ObservableObject {
	// MARK: -  PROPERTY
	
	// 3D Navigation Drawer
	@Published var currentDrawerTab: String = "Discover KR"
	@Published var showMenu: Bool = false
	
	// ContentView tabs
	@Published var locationStates: [LocationState]
	@Published var tabItems: [Tab]
	@Published var currentTab: String = ""
	
	
	// All loaded locations
	@Published var locations: [Location]
	
	// Current location on map
	@Published var mapLocation: Location {
		didSet {
			updateMapRegion(location: mapLocation)
		}
	}
	
	// Current region on map
	@Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
	let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
	
	// Show list of location
	@Published var showLocationList: Bool = false
	
	// Show location detail via sheet
	@Published var sheetLocation: Location? = nil
	
	// transition pre/next
	@Published var isNextBtnPressed: Bool = false
	
	// Google AD placement
	let adPlacement: Int = 5
	
	// Show App info
	@Published var isShowAppInfo: Bool = false

	// Favorites
	@Published var favoriteIDs: Set<String> = []

	// Search & Filter
	@Published var searchText: String = ""
	@Published var showFavoritesOnly: Bool = false

	var searchResults: [Location] {
		guard !searchText.isEmpty else { return [] }
		return locations.filter {
			$0.name.localizedCaseInsensitiveContains(searchText) ||
			$0.cityName.localizedCaseInsensitiveContains(searchText) ||
			$0.headline.localizedCaseInsensitiveContains(searchText)
		}
	}

	var favoriteLocations: [Location] {
		locations.filter { favoriteIDs.contains($0.id) }
	}

	func isFavorite(_ location: Location) -> Bool {
		favoriteIDs.contains(location.id)
	}

	func toggleFavorite(_ location: Location) {
		withAnimation(.spring()) {
			if favoriteIDs.contains(location.id) {
				favoriteIDs.remove(location.id)
			} else {
				favoriteIDs.insert(location.id)
			}
		}
		UserDefaults.standard.set(Array(favoriteIDs), forKey: "favoriteLocationIDs")
	}

	// init
	init() {
		let fetchData: [Location] = Bundle.main.decode("discoverDB.json")
		self.locations = fetchData
		self.mapLocation = fetchData.first!
		
		let fetchDataState: [LocationState] = Bundle.main.decode("discoverState.json")
		self.locationStates = fetchDataState
		self.tabItems = [
			Tab(tab: "Seoul", locations: fetchDataState[0].body),
			Tab(tab: "Busan", locations: fetchDataState[1].body),
			Tab(tab: "Jeju", locations: fetchDataState[2].body),
			Tab(tab: "Incheon", locations: fetchDataState[3].body),
			Tab(tab: "Daejeon", locations: fetchDataState[4].body),
			Tab(tab: "Daegu", locations: fetchDataState[5].body),
			Tab(tab: "Ulsan", locations: fetchDataState[6].body),
			Tab(tab: "Gwangju", locations: fetchDataState[7].body),
			Tab(tab: "Gyeonggi", locations: fetchDataState[8].body),
			Tab(tab: "Gangwon", locations: fetchDataState[9].body),
			Tab(tab: "Chungcheong", locations: fetchDataState[10].body),
			Tab(tab: "Gyeongsang", locations: fetchDataState[11].body),
			Tab(tab: "Jeolla", locations: fetchDataState[12].body),
		]
		
		self.updateMapRegion(location: fetchData.first!)

		let savedIDs = UserDefaults.standard.stringArray(forKey: "favoriteLocationIDs") ?? []
		self.favoriteIDs = Set(savedIDs)
	}
	
	
	
	// MARK: -  FUNCTION
	private func updateMapRegion(location: Location) {
		withAnimation(.easeInOut) {
			mapRegion = MKCoordinateRegion(
				center: location.coordinates,
				span: mapSpan)
		}
	}
	
	func toggleLocationList() {
		withAnimation(.easeInOut) {
			showLocationList.toggle()
		}
	}
	
	func showNextLocation(location: Location) {
		withAnimation(.easeInOut) {
			mapLocation = location
			showLocationList = false
		}
	}
	
	func prevBtnPressed() {
		isNextBtnPressed = false
		// Get the cureent index
		guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
			print("Could not find current index in location array")
			return
		}
		
		// Check if the prevIndex is valid
		let prevIndex = currentIndex - 1
		guard locations.indices.contains(prevIndex) else {
			
			// Prev index is Not valid
			// move Last Index
			guard let lastLocation = locations.last else { return }
			showNextLocation(location: lastLocation)
			return
		}
		
			// Next index is Valid
		let lastLocation = locations[prevIndex]
		showNextLocation(location: lastLocation)
		
	}
	
	func nextBtnPressed() {
		isNextBtnPressed = true
		// Get the cureent index
		guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
			print("Could not find current index in location array")
			return
		}
		
		// Check if the nextIndex is valid
		let nextIndex = currentIndex + 1
		guard locations.indices.contains(nextIndex) else {
			
			// Next index is Not valid
			// Restart from 0
			guard let firstLocation = locations.first else { return }
			showNextLocation(location: firstLocation)
			return
		}
		
			// Next index is Valid
		let nextLocation = locations[nextIndex]
		showNextLocation(location: nextLocation)
		
	}
}
