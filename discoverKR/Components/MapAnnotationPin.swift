//
//  MapAnnotationPin.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/01.
//

import SwiftUI

struct MapAnnotationPin: View {
	
	let accentColor = Color("AppMint")
	
	var body: some View {
		VStack (spacing: 0) {
			Image(systemName: "map.circle.fill")
				.resizable()
				.scaledToFit()
				.frame(width: 30, height: 30)
				.font(.headline)
				.foregroundColor(.white)
				.padding(6)
				.background(accentColor)
				.clipShape(Circle())
			
			Image(systemName: "triangle.fill")
				.resizable()
				.scaledToFit()
				.foregroundColor(accentColor)
				.frame(width: 10, height: 10)
				.rotationEffect(Angle(degrees: 180))
				.offset(y: -3)
				.padding(.bottom, 40)
		} //: VSTACK
	}
}

struct MapAnnotationPin_Previews: PreviewProvider {
	static var previews: some View {
		MapAnnotationPin()
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
