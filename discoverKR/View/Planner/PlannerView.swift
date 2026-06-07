//
//  PlannerView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import SwiftUI

struct PlannerView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject var planner: PlannerViewModel
	@State private var showNewPlan = false

	// MARK: -  BODY
	var body: some View {
		NavigationStack {
			Group {
				if planner.plans.isEmpty {
					emptyState
				} else {
					planList
				}
			}
			.navigationTitle("My Trips")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showNewPlan = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title3)
							.foregroundColor(Color("AppMint"))
					}
				}
			}
			.sheet(isPresented: $showNewPlan) {
				NewPlanSheet()
			}
		}
	}
}

// MARK: -  EXTENSION
extension PlannerView {

	// Empty state
	private var emptyState: some View {
		VStack(spacing: 24) {
			Image(systemName: "map.fill")
				.font(.system(size: 64))
				.foregroundColor(Color("AppMint").opacity(0.5))
			VStack(spacing: 8) {
				Text("No trips planned yet")
					.font(.title2.bold())
				Text("Create your first trip and start\nadding places to visit")
					.font(.subheadline)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
			}
			Button {
				showNewPlan = true
			} label: {
				Label("New Trip", systemImage: "plus")
					.font(.headline)
					.foregroundColor(.white)
					.padding(.horizontal, 36)
					.padding(.vertical, 14)
					.background(Color("AppMint"))
					.cornerRadius(25)
			}
		}
		.padding()
	}

	// Plan list
	private var planList: some View {
		List {
			ForEach(planner.plans) { plan in
				NavigationLink(destination: PlanDetailView(plan: plan)) {
					planCard(plan)
				}
				.listRowBackground(Color.clear)
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
			}
			.onDelete { offsets in
				offsets.forEach { planner.deletePlan(planner.plans[$0]) }
			}
		}
		.listStyle(.plain)
	}

	// Plan card
	private func planCard(_ plan: TravelPlan) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(plan.name)
					.font(.headline)
					.foregroundColor(Color("AppPurple"))
				Spacer()
				Text("\(plan.days.count) days")
					.font(.caption.bold())
					.padding(.horizontal, 10)
					.padding(.vertical, 4)
					.background(Color("AppMint").opacity(0.15))
					.foregroundColor(Color("AppMint"))
					.cornerRadius(8)
			}
			Label(plan.dateRangeText, systemImage: "calendar")
				.font(.subheadline)
				.foregroundColor(.secondary)
			if plan.totalItems > 0 {
				VStack(alignment: .leading, spacing: 4) {
					ProgressView(value: Double(plan.visitedItems), total: Double(plan.totalItems))
						.tint(Color("AppMint"))
					Text("\(plan.visitedItems)/\(plan.totalItems) places visited")
						.font(.caption)
						.foregroundColor(.secondary)
				}
			} else {
				Text("Tap a location → Add to Trip")
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
		.padding()
		.background(.ultraThickMaterial)
		.cornerRadius(14)
		.shadow(color: .black.opacity(0.07), radius: 5, x: 0, y: 2)
	}
}

// MARK: -  PREVIEW
struct PlannerView_Previews: PreviewProvider {
	static var previews: some View {
		PlannerView()
			.environmentObject(PlannerViewModel())
	}
}
