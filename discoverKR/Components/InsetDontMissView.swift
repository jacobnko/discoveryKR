//
//  InsetDontMissView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/03/02.
//

import SwiftUI

struct InsetDontMissView: View {
	// MARK: -  PROPERTY
	
	let location: Location
	
	// MARK: -  BODY
	var body: some View {
		GroupBox {
			TabView {
				ForEach(location.donMiss, id: \.self) { item in
					Text(item)
				} //: LOOP
			} //: TAB
			.tabViewStyle(.page)
			.frame(minHeight: 148, idealHeight: 168, maxHeight: 180)
		} //: BOX
	}
}

struct InsetDontMissView_Previews: PreviewProvider {
	static let locations: [Location] = Bundle.main.decode("discoverDB.json")
	static var previews: some View {
		InsetDontMissView(location: locations[0])
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
