//
//  LoadImage.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/21.
//

import SwiftUI

struct LoadImage: View {
	// MARK: -  PROPERTY

	let imageUrl: URL
	var width: CGFloat? = nil
	var height: CGFloat? = nil
	var contentMode: ContentMode = .fill

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
					.aspectRatio(contentMode: contentMode)
			case .failure:
				Rectangle()
					.fill(Color.gray.opacity(0.15))
					.overlay(
						Image(systemName: "photo")
							.foregroundColor(.gray)
					)
			@unknown default:
				EmptyView()
			}
		}
		.frame(width: width, height: height)
	}
}

// MARK: -  PREVIEW
struct LoadImage_Previews: PreviewProvider {
	static var previews: some View {
		let url = URL(string: "https://jacobko.info/assets/images/awesomKR/Seoul/Gyeongbokgung-1.jpeg")!
		LoadImage(imageUrl: url, width: 200, height: 200)
	}
}
