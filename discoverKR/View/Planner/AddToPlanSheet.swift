//
//  AddToPlanSheet.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import SwiftUI

struct AddToPlanSheet: View {
	// MARK: -  PROPERTY
	@EnvironmentObject var planner: PlannerViewModel
	@Environment(\.dismiss) var dismiss

	let location: Location

	@State private var selectedPlanID: UUID?
	@State private var selectedDayID: UUID?
	@State private var showNewPlan = false

	private var canAdd: Bool { selectedPlanID != nil && selectedDayID != nil }

	// MARK: -  BODY
	var body: some View {
		NavigationStack {
			Group {
				if planner.plans.isEmpty {
					emptyState
				} else {
					pickerList
				}
			}
			.navigationTitle("Add to Trip")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear {
				if planner.plans.isEmpty {
					showNewPlan = true
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") { dismiss() }
						.foregroundColor(.secondary)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Add") {
						guard let planID = selectedPlanID,
							  let dayID = selectedDayID else { return }
						planner.addLocation(location, toPlanID: planID, dayID: dayID)
						UINotificationFeedbackGenerator().notificationOccurred(.success)
						dismiss()
					}
					.disabled(!canAdd)
					.fontWeight(.bold)
					.foregroundColor(canAdd ? Color("AppMint") : .gray)
				}
			}
			.sheet(isPresented: $showNewPlan) {
				NewPlanSheet(initialName: location.name)
			}
		}
	}
}

// MARK: -  EXTENSION
extension AddToPlanSheet {

	// Empty state
	private var emptyState: some View {
		VStack(spacing: 24) {
			Image(systemName: "calendar.badge.plus")
				.font(.system(size: 56))
				.foregroundColor(Color("AppMint").opacity(0.5))
			VStack(spacing: 8) {
				Text("No trips yet")
					.font(.title2.bold())
				Text("Create a trip first to add places")
					.font(.subheadline)
					.foregroundColor(.secondary)
			}
			Button {
				showNewPlan = true
			} label: {
				Label("Create a Trip", systemImage: "plus")
					.font(.headline)
					.foregroundColor(.white)
					.padding(.horizontal, 32)
					.padding(.vertical, 14)
					.background(Color("AppMint"))
					.cornerRadius(25)
			}
		}
		.padding()
	}

	// Plan + Day picker
	private var pickerList: some View {
		List {
			// New plan shortcut
			Button {
				showNewPlan = true
			} label: {
				Label("Create New Trip", systemImage: "plus.circle.fill")
					.foregroundColor(Color("AppMint"))
			}

			ForEach(planner.plans) { plan in
				Section {
					ForEach(plan.days) { day in
						Button {
							selectedPlanID = plan.id
							selectedDayID = day.id
						} label: {
							HStack {
								VStack(alignment: .leading, spacing: 2) {
									Text(day.dayLabel)
										.font(.subheadline)
										.foregroundColor(.primary)
									Text("\(day.items.count) places")
										.font(.caption)
										.foregroundColor(.secondary)
								}
								Spacer()
								if selectedPlanID == plan.id && selectedDayID == day.id {
									Image(systemName: "checkmark.circle.fill")
										.foregroundColor(Color("AppMint"))
								}
							}
						}
					}
				} header: {
					Text(plan.name)
						.font(.headline)
						.foregroundColor(Color("AppPurple"))
				}
			}
		}
		.listStyle(.insetGrouped)
	}
}

// MARK: -  PREVIEW
struct AddToPlanSheet_Previews: PreviewProvider {
	static let locations: [Location] = Bundle.main.decode("discoverDB.json")
	static var previews: some View {
		AddToPlanSheet(location: locations[0])
			.environmentObject(PlannerViewModel())
	}
}
