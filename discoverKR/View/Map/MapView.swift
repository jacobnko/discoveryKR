//
//  MapView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI
import MapKit

struct MapView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	let maxWidthForIpad: CGFloat = 700
	
	// MARK: -  BODY
	var body: some View {
		ZStack {
			mapLayer
				.ignoresSafeArea(edges: .top)
			
			VStack (spacing: 0) {
				header
					.frame(maxWidth: maxWidthForIpad)
				Spacer()
				locationPreviewStack
			} //: VSTACK
		} //: ZSTACK
		.sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
			MoreDetailView(location: location)
		}
	}
}

// MARK: -  PREVIEW
struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
			.environmentObject(MapViewModel())
	}
}

// MARK: -  EXTENSION
extension MapView {
	// MAP
	private var mapLayer: some View {
		Map(coordinateRegion: $vm.mapRegion,
				annotationItems: vm.locations,
				annotationContent: { location in
			MapAnnotation(coordinate: location.coordinates) {
				MapAnnotationPin()
					.scaleEffect(vm.mapLocation == location ? 1 : 0.6)
					.shadow(radius: 10)
					.onTapGesture {
						vm.showNextLocation(location: location)
					}
			}
		})
	}
	
	// HEADER
	private var header: some View {
		VStack {
			
			Button {
				vm.toggleLocationList()
			} label: {
				Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
					.font(.title3)
					.fontWeight(.bold)
					.foregroundColor(.primary)
					.frame(height: 55)
					.frame(maxWidth: .infinity)
					.animation(.none, value: vm.mapLocation)
					.overlay(alignment: .leading) {
						Image(systemName: "arrow.down")
							.font(.headline)
							.foregroundColor(.primary)
							.padding()
							.rotationEffect(Angle(degrees: vm.showLocationList ? 180 : 0))
					}
			}
			if vm.showLocationList {
				Divider()
				MapListView()
					.transition(.opacity.combined(with: .move(edge: .top)))
			}
			
		} //: VSTACK
		.background(.thickMaterial)
		.cornerRadius(10)
		.shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
		.padding()
	}
	
	
	// LOCATION PREVIEW
	private var locationPreviewStack: some View {
		ZStack {
			ForEach(vm.locations) { location in
				if vm.mapLocation == location {
					MapPreviewView(location: location)
						.shadow(color: Color.black.opacity(0.3), radius: 20)
						.padding()
						.frame(maxWidth: maxWidthForIpad)
						.frame(maxWidth: .infinity) // transition 을 위한 infinity maxWidth 설정
						.transition(
							vm.isNextBtnPressed
							? .asymmetric(
								insertion: .move(edge: .trailing),
								removal: .move(edge: .leading))
							: .asymmetric(
								insertion: .move(edge: .leading),
								removal: .move(edge: .trailing))
						)
				}
			} //: LOOP
		} //: ZSTACK
	}
}
