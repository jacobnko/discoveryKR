//
//  PlannerViewModel.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import SwiftUI

class PlannerViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var plans: [TravelPlan] = [] {
		didSet { save() }
	}

	private let saveKey = "discoverKR.travelPlans"

	init() { load() }

	// MARK: -  PLAN CRUD

	func createPlan(name: String, startDate: Date, endDate: Date) {
		var days: [PlanDay] = []
		let cal = Calendar.current
		var current = cal.startOfDay(for: startDate)
		let end = cal.startOfDay(for: endDate)
		while current <= end {
			days.append(PlanDay(date: current, items: []))
			current = cal.date(byAdding: .day, value: 1, to: current) ?? end
		}
		plans.append(TravelPlan(name: name, startDate: startDate, endDate: endDate, days: days))
	}

	func deletePlan(_ plan: TravelPlan) {
		plans.removeAll { $0.id == plan.id }
	}

	// MARK: -  ITEM MANAGEMENT

	func addLocation(_ location: Location, toPlanID planID: UUID, dayID: UUID) {
		guard let pi = plans.firstIndex(where: { $0.id == planID }),
			  let di = plans[pi].days.firstIndex(where: { $0.id == dayID }) else { return }
		let item = PlanItem(
			locationID: location.id,
			locationName: location.name,
			locationCity: location.cityName,
			imageURL: location.imageNames.first ?? ""
		)
		plans[pi].days[di].items.append(item)
	}

	func toggleVisited(item: PlanItem, dayID: UUID, planID: UUID) {
		guard let pi = plans.firstIndex(where: { $0.id == planID }),
			  let di = plans[pi].days.firstIndex(where: { $0.id == dayID }),
			  let ii = plans[pi].days[di].items.firstIndex(where: { $0.id == item.id }) else { return }
		plans[pi].days[di].items[ii].isVisited.toggle()
	}

	func removeItems(_ offsets: IndexSet, dayID: UUID, planID: UUID) {
		guard let pi = plans.firstIndex(where: { $0.id == planID }),
			  let di = plans[pi].days.firstIndex(where: { $0.id == dayID }) else { return }
		plans[pi].days[di].items.remove(atOffsets: offsets)
	}

	func moveItems(from source: IndexSet, to destination: Int, dayID: UUID, planID: UUID) {
		guard let pi = plans.firstIndex(where: { $0.id == planID }),
			  let di = plans[pi].days.firstIndex(where: { $0.id == dayID }) else { return }
		plans[pi].days[di].items.move(fromOffsets: source, toOffset: destination)
	}

	// MARK: -  PERSISTENCE

	private func save() {
		if let encoded = try? JSONEncoder().encode(plans) {
			UserDefaults.standard.set(encoded, forKey: saveKey)
		}
	}

	private func load() {
		guard let data = UserDefaults.standard.data(forKey: saveKey),
			  let decoded = try? JSONDecoder().decode([TravelPlan].self, from: data) else { return }
		plans = decoded
	}
}
