//
//  Location.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import Foundation
import MapKit

struct LocationState: Codable {
	var state : String
	var body : [Location]
}

struct Location: Codable, Identifiable, Equatable {
	var id: String
	var name: String
	var cityName: String
	var headline: String
	var description: String
	var donMiss: [String]
	var transportation: String
	var link: String
	var address: String
	var phone: String
	var availableHours: String
	var parking: String
	var fee: String
	var others: String
	var imageNames: [String]
	var youtubeID: String
	var latitude: Double
	var longitude: Double
	var copyright: String

	// Computed Property
	var coordinates: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
	
	// Equatable
	static func == (lhs: Location, rhs: Location) -> Bool {
		lhs.id == rhs.id
	}
}

struct Tab: Identifiable {
	var id = UUID().uuidString
	var tab: String
	var locations: [Location]
}
