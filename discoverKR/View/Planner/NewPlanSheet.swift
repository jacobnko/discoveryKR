//
//  NewPlanSheet.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import SwiftUI

struct NewPlanSheet: View {
	// MARK: -  PROPERTY
	@EnvironmentObject var planner: PlannerViewModel
	@Environment(\.dismiss) var dismiss

	var initialName: String = ""
	@State private var name: String = ""
	@State private var startDate: Date = Date()
	@State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()

	private var isValid: Bool {
		!name.trimmingCharacters(in: .whitespaces).isEmpty && startDate <= endDate
	}

	private var dayCount: Int {
		(Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0) + 1
	}

	// MARK: -  BODY
	var body: some View {
		NavigationStack {
			Form {
				Section("Trip name") {
					TextField("e.g. Seoul Weekend", text: $name)
						.onAppear {
							if name.isEmpty { name = initialName }
						}
				}

				Section("Dates") {
					DatePicker("Start", selection: $startDate, displayedComponents: .date)
						.onChange(of: startDate) { _, newVal in
							if endDate < newVal { endDate = newVal }
						}
					DatePicker("End", selection: $endDate, in: startDate..., displayedComponents: .date)
				}

				Section {
					HStack {
						Image(systemName: "calendar")
							.foregroundColor(Color("AppMint"))
						Text("\(dayCount) days")
							.foregroundColor(.secondary)
					}
				}
			}
			.navigationTitle("New Trip")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") { dismiss() }
						.foregroundColor(.secondary)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Create") {
						planner.createPlan(
							name: name.trimmingCharacters(in: .whitespaces),
							startDate: startDate,
							endDate: endDate
						)
						dismiss()
					}
					.disabled(!isValid)
					.fontWeight(.bold)
					.foregroundColor(isValid ? Color("AppMint") : .gray)
				}
			}
		}
	}
}

// MARK: -  PREVIEW
struct NewPlanSheet_Previews: PreviewProvider {
	static var previews: some View {
		NewPlanSheet()
			.environmentObject(PlannerViewModel())
	}
}
