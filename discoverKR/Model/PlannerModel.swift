//
//  PlannerModel.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import Foundation

struct TravelPlan: Codable, Identifiable {
	var id = UUID()
	var name: String
	var startDate: Date
	var endDate: Date
	var days: [PlanDay]

	var dateRangeText: String {
		let f = DateFormatter()
		f.dateFormat = "MMM d"
		return "\(f.string(from: startDate)) – \(f.string(from: endDate))"
	}
	var totalItems: Int { days.reduce(0) { $0 + $1.items.count } }
	var visitedItems: Int { days.reduce(0) { $0 + $1.items.filter(\.isVisited).count } }
}

struct PlanDay: Codable, Identifiable {
	var id = UUID()
	var date: Date
	var items: [PlanItem]

	var dayLabel: String {
		let f = DateFormatter()
		f.dateFormat = "MM/dd (EEE)"
		return f.string(from: date)
	}
}

struct PlanItem: Codable, Identifiable {
	var id = UUID()
	var locationID: String
	var locationName: String
	var locationCity: String
	var imageURL: String
	var isVisited: Bool = false
}
