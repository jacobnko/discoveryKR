//
//  MoreDetailImage.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/21.
//

import SwiftUI

struct MoreDetailImage: View {
	// MARK: -  PROPERTY

	let imageUrl: URL

	// MARK: -  BODY
	var body: some View {
		AsyncImage(url: imageUrl) { phase in
			switch phase {
			case .empty:
				Rectangle()
					.fill(Color.gray.opacity(0.15))
					.overlay(ProgressView())
			case .success(let image):
				image
					.resizable()
					.scaledToFill()
			case .failure:
				Rectangle()
					.fill(Color.gray.opacity(0.15))
					.overlay(
						VStack(spacing: 8) {
							Image(systemName: "exclamationmark.triangle")
								.font(.largeTitle)
								.foregroundColor(.gray)
							Text("Image unavailable")
								.font(.caption)
								.foregroundColor(.gray)
						}
					)
			@unknown default:
				EmptyView()
			}
		}
	}
}

// MARK: -  PREVIEW
struct MoreDetailImage_Previews: PreviewProvider {
	static var previews: some View {
		let url = URL(string: "https://jacobko.info/assets/images/awesomKR/Seoul/Gyeongbokgung-1.jpeg")!
		MoreDetailImage(imageUrl: url)
			.frame(width: 300, height: 200)
			.cornerRadius(12)
	}
}
