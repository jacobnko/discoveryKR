//
//  ShimmerView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2026/06/03.
//

import SwiftUI

struct ShimmerView: View {
	// MARK: -  PROPERTY

	var cornerRadius: CGFloat = 0
	@State private var isAnimating = false

	// MARK: -  BODY
	var body: some View {
		RoundedRectangle(cornerRadius: cornerRadius)
			.fill(
				LinearGradient(
					gradient: Gradient(colors: [
						Color.gray.opacity(0.12),
						Color.gray.opacity(0.30),
						Color.gray.opacity(0.12)
					]),
					startPoint: isAnimating ? .topLeading : .bottomTrailing,
					endPoint: isAnimating ? .bottomTrailing : .topLeading
				)
			)
			.onAppear {
				withAnimation(
					.linear(duration: 1.2)
					.repeatForever(autoreverses: false)
				) {
					isAnimating = true
				}
			}
	}
}

// MARK: -  PREVIEW
struct ShimmerView_Previews: PreviewProvider {
	static var previews: some View {
		ShimmerView(cornerRadius: 12)
			.frame(width: 90, height: 90)
			.padding()
	}
}
