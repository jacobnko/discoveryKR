//
//  SettingLabelView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct SettingLabelView: View {
	// MARK: -  PROPERTY
	
	var labelText: String
	var labelImage: String
	
	// MARK: -  BODY
	var body: some View {
		HStack {
			Text(labelText).fontWeight(.bold)
			Spacer()
			Image(systemName: labelImage)
		}
	}
}

struct SettingLabelView_Previews: PreviewProvider {
	static var previews: some View {
		SettingLabelView(labelText: "Fruits-Dic", labelImage: "info.circle")
			.preferredColorScheme(.dark)
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
