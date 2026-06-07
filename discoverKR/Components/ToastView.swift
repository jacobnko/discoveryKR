//
//  ToastView.swift
//  DiscoverKR
//
//  Small auto-dismissing toast shown on favorite add/remove.
//

import SwiftUI

struct ToastMessage: Equatable, Identifiable {
	let id = UUID()
	let text: String
	let systemImage: String
	let isAdd: Bool
}

struct ToastView: View {
	let message: ToastMessage

	var body: some View {
		HStack(spacing: 8) {
			Image(systemName: message.systemImage)
				.foregroundColor(message.isAdd ? .red : .white.opacity(0.9))
			Text(message.text)
				.font(.subheadline.weight(.semibold))
				.foregroundColor(.white)
		}
		.padding(.horizontal, 18)
		.padding(.vertical, 12)
		.background(
			Capsule()
				.fill(.black.opacity(0.82))
		)
		.shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
	}
}

// MARK: - Overlay modifier
struct ToastOverlay: ViewModifier {
	@EnvironmentObject private var vm: MapViewModel

	func body(content: Content) -> some View {
		content
			.overlay(alignment: .bottom) {
				if let toast = vm.toast {
					ToastView(message: toast)
						.padding(.bottom, 90)
						.transition(.move(edge: .bottom).combined(with: .opacity))
						.allowsHitTesting(false)
						.zIndex(999)
				}
			}
	}
}

extension View {
	/// Presents the favorite add/remove toast driven by `MapViewModel.toast`.
	func favoriteToast() -> some View {
		modifier(ToastOverlay())
	}
}
