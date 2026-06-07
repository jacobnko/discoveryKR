//
//  FavoriteButton.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/15.
//

import SwiftUI

struct FavoriteButton: View {
	// MARK: -  PROPERTY
	@EnvironmentObject private var vm: MapViewModel
	let location: Location

	// MARK: -  BODY
	var body: some View {
		Button {
			UIImpactFeedbackGenerator(style: .medium).impactOccurred()
			vm.toggleFavorite(location)
		} label: {
			Image(systemName: vm.isFavorite(location) ? "heart.fill" : "heart")
				.font(.headline)
				.foregroundColor(vm.isFavorite(location) ? .red : Color("AppPurple"))
		}
		.accessibilityLabel(vm.isFavorite(location) ? "Remove from favorites" : "Add to favorites")
	}
}

// MARK: -  PREVIEW
struct FavoriteButton_Previews: PreviewProvider {
	static let locations: [Location] = Bundle.main.decode("discoverDB.json")

	static var previews: some View {
		FavoriteButton(location: locations[0])
			.environmentObject(MapViewModel())
	}
}
