//
//  HeadingView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/02.
//

import SwiftUI

struct HeadingView: View {
	// MARK: -  PROPERTY
	
	var headingImage: String
	var headingText: String
	
	// MARK: -  BODY
	var body: some View {
		
		HStack {
			Image(systemName: headingImage)
				.foregroundColor(Color("AppMint"))
				.imageScale(.large)
			
			Text(headingText)
				.font(.title3)
				.fontWeight(.bold)
			
		} //: HSTACK
		.padding(.top, 20)
	}
}


// MARK: -  PREVIEW
struct HeadingView_Previews: PreviewProvider {
	static var previews: some View {
		HeadingView(headingImage: "photo.on.rectangle.angled", headingText: "Heading sample")
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
