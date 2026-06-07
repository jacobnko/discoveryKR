//
//  SettingView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct SettingView: View {
	// MARK: -  PROPERTY
	@EnvironmentObject var vm: MapViewModel
	
	
	// MARK: -  BODY
	var body: some View {
		
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .center, spacing: 20) {

					// MARK: -  SECTION1 : APPLICATION
					GroupBox(
						label: SettingLabelView(labelText: "Application", labelImage: "apps.iphone")
					) {
						SettingsRowView(name: "Developer", content: "Jacob Taehun Ko")
						SettingsRowView(name: "Compatibility", content: "iOS16.0")
						SettingsRowView(name: "Developer Site", linkLabel: "Jacob's DevLog", linkDestination: "https://jacobko.info")
						SettingsRowView(name: "Privacy", linkLabel: "Go to Privacy", linkDestination: "https://jacobko.info/awesomeKRPrivacy/")
						SettingsRowView(name: "Terms & Conditions", linkLabel: "Go to Site", linkDestination: "https://jacobko.info/awesomeKRTermsConditions/")
						SettingsRowView(name: "Framework", content: "SwiftUI")
						SettingsRowView(name: "Version", content: "1.1")
					} //: GROUP

					GroupBox(
						label: SettingLabelView(labelText: "License", labelImage: "c.circle")
					) {
						Divider().padding(.vertical, 4)
						HStack(alignment: .center, spacing: 10) {
							Image("license")
								.resizable()
								.scaledToFit()
								.frame(width: 120)
							Spacer()
							Text("The user can freely use the public work regardless of its commercial use without fee, and can change it to create secondary work.")
								.font(.footnote)
						} //: HSTACK
						SettingsRowView(name: "License Site", linkLabel: "Visit Korea", linkDestination: "https://english.visitkorea.or.kr/enu/index.kto")
					}
				} //: VSTACK
				.padding()
			} //: SCROLL
			.navigationTitle("APP INFORMATION")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						vm.isShowAppInfo = false
					} label: {
						Image(systemName: "xmark")
							.font(.title2)
							.foregroundColor(Color("AppPurple"))
					}
					.accessibilityLabel("Close")
				}
			}
		} //: NAVIGATION
	}
}

// MARK: -  PREVIEW
struct SettingView_Previews: PreviewProvider {
	static var previews: some View {
		SettingView()
			.preferredColorScheme(.dark)
			.environmentObject(MapViewModel())
	}
}
