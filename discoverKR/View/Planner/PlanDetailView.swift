//
//  PlanDetailView.swift
//  DiscoverKR
//

import SwiftUI

struct PlanDetailView: View {
	@EnvironmentObject var planner: PlannerViewModel
	@EnvironmentObject var vm: MapViewModel
	let plan: TravelPlan

	@State private var selectedLocation: Location?

	var currentPlan: TravelPlan {
		planner.plans.first(where: { $0.id == plan.id }) ?? plan
	}

	// MARK: -  BODY
	var body: some View {
		List {
			ForEach(currentPlan.days) { day in
				Section {
					if day.items.isEmpty {
						Label("No places yet — open a location and tap Add to Trip Plan", systemImage: "mappin.slash")
							.font(.caption)
							.foregroundColor(.secondary)
							.padding(.vertical, 6)
					} else {
						ForEach(day.items) { item in
							PlanItemRow(item: item, day: day, plan: currentPlan)
								.contentShape(Rectangle())
								.onTapGesture {
									if let loc = vm.locations.first(where: { $0.id == item.locationID }) {
										selectedLocation = loc
									}
								}
						}
						.onDelete { offsets in
							planner.removeItems(offsets, dayID: day.id, planID: plan.id)
						}
						.onMove { from, to in
							planner.moveItems(from: from, to: to, dayID: day.id, planID: plan.id)
						}
					}
				} header: {
					HStack {
						Text(day.dayLabel)
							.font(.subheadline.bold())
						Spacer()
						if !day.items.isEmpty {
							Text("\(day.items.filter(\.isVisited).count)/\(day.items.count) visited")
								.font(.caption)
								.foregroundColor(Color("AppMint"))
						}
					}
				}
			}
		}
		.navigationTitle(currentPlan.name)
		.navigationBarTitleDisplayMode(.large)
		.toolbar { EditButton() }
		.sheet(item: $selectedLocation) { loc in
			MoreDetailView(location: loc)
		}
	}
}

// MARK: -  PLAN ITEM ROW
struct PlanItemRow: View {
	@EnvironmentObject var planner: PlannerViewModel
	let item: PlanItem
	let day: PlanDay
	let plan: TravelPlan

	var body: some View {
		HStack(spacing: 12) {
			// Thumbnail
			RemoteImage(urlString: item.imageURL, cornerRadius: 8)
				.frame(width: 56, height: 56)
				.clipped()

			// Info
			VStack(alignment: .leading, spacing: 4) {
				Text(item.locationName)
					.font(.headline)
					.strikethrough(item.isVisited, color: .secondary)
					.foregroundColor(item.isVisited ? .secondary : .primary)
				Text(item.locationCity)
					.font(.caption)
					.foregroundColor(.secondary)
			}

			Spacer()

			// Visit toggle
			Button {
				UIImpactFeedbackGenerator(style: .light).impactOccurred()
				planner.toggleVisited(item: item, dayID: day.id, planID: plan.id)
			} label: {
				Image(systemName: item.isVisited ? "checkmark.circle.fill" : "circle")
					.font(.title2)
					.foregroundColor(item.isVisited ? Color("AppMint") : .gray)
			}
			.buttonStyle(.plain)
		}
		.padding(.vertical, 4)
	}
}

// MARK: -  PREVIEW
struct PlanDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			PlanDetailView(plan: TravelPlan(
				name: "Seoul Trip",
				startDate: Date(),
				endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
				days: []
			))
		}
		.environmentObject(PlannerViewModel())
		.environmentObject(MapViewModel())
	}
}
