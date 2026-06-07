//
//  MapListView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct MapListView: View {
	@EnvironmentObject private var vm: MapViewModel

	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			LazyVStack(spacing: 0) {
				ForEach(vm.locations) { location in
					Button {
						vm.showNextLocation(location: location)
					} label: {
						listRowView(location: location)
					}
					.buttonStyle(.plain)
					Divider()
						.padding(.leading, 68)
				}
			}
		}
		.frame(maxHeight: 320)
	}
}

// MARK: - Preview
struct MapListView_Previews: PreviewProvider {
	static var previews: some View {
		MapListView()
			.environmentObject(MapViewModel())
	}
}

// MARK: - Row
extension MapListView {
	private func listRowView(location: Location) -> some View {
		HStack(spacing: 12) {
			RemoteImage(urlString: location.imageNames.first ?? "", cornerRadius: 8)
				.frame(width: 44, height: 44)
				.clipped()

			VStack(alignment: .leading, spacing: 2) {
				Text(location.name)
					.font(.headline)
					.foregroundColor(.primary)
				Text(location.cityName)
					.font(.subheadline)
					.foregroundColor(.secondary)
			}
			.frame(maxWidth: .infinity, alignment: .leading)

			Image(systemName: "chevron.right")
				.font(.caption)
				.foregroundColor(.secondary)
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 10)
		.contentShape(Rectangle())
	}
}
