//
//  MapPreviewView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/01.
//

import SwiftUI
struct MapPreviewView: View {
	// MARK: -  PROPERTY
	
	@EnvironmentObject private var vm: MapViewModel
	let location: Location
	
	// MARK: -  BODY
	var body: some View {
		HStack(alignment: .bottom, spacing: 0) {
			VStack (alignment: .leading, spacing: 16) {
				imageSection
				titleSection
				
			} //: VSTACK
			
			VStack (spacing: 15) {
				learnMoreBtn
				
				HStack {
					prevBtn
					nextBtn
				} //: HSTACK
				
			} //: VSTACK
		} //: HSTACK
		.padding(20)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(.ultraThinMaterial)
				.offset(y: 65)
		)
		.cornerRadius(10)
	}
}

// MARK: -  PREVIEW
struct MapPreviewView_Previews: PreviewProvider {
	static let locations: [Location] = Bundle.main.decode("discoverDB.json")
	
	static var previews: some View {
		ZStack {
			Color.blue.ignoresSafeArea()
			
			MapPreviewView(location: locations[0])
				.padding()
		}
		.previewDevice("iPhone 13")  //: ZSTACK
		.environmentObject(MapViewModel())
		
		ZStack {
			Color.blue.ignoresSafeArea()
			
			MapPreviewView(location: locations[0])
				.padding()
		}
		.previewDevice("iPhone SE (2nd generation)")  //: ZSTACK
		.environmentObject(MapViewModel())
	}
}

// MARK: -  EXTENSION
extension MapPreviewView {
	
	// thumbnail image
	private var imageSection: some View {
		Button {
			vm.sheetLocation = location
		} label: {
			RemoteImage(urlString: location.imageNames.first ?? "", cornerRadius: 10)
				.frame(width: 100, height: 100)
				.clipped()
			.padding(6)
			.background(Color("AppPurple"))
			.cornerRadius(10)
		}
	}
	
	// Title Section
	private var titleSection: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(location.name)
				.font(.title2)
				.fontWeight(.bold)
			
			Text(location.cityName)
				.font(.subheadline)
		} //: VSTACK
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	// Button Section
	private var learnMoreBtn: some View {
		Button {
			vm.sheetLocation = location
		} label: {
			Text("Learn more")
				.font(.headline)
				.foregroundColor(Color("AppMint"))
				.frame(width: 110, height: 30)
		}
		.buttonStyle(.bordered)
	}
	
	private var prevBtn: some View {
		Button {
			vm.prevBtnPressed()
		} label: {
			Image(systemName: "arrowshape.turn.up.left.fill")
				.font(.headline)
				.frame(width: 40, height: 30)
		}
		.buttonStyle(.bordered)
		
	}
	
	private var nextBtn: some View {
		Button {
			vm.nextBtnPressed()
		} label: {
			Image(systemName: "arrowshape.turn.up.right.fill")
				.font(.headline)
				.frame(width: 40, height: 30)
		}
		.buttonStyle(.bordered)
		
	}
}
