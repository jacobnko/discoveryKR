//
//  OffsetModifier.swift

import SwiftUI

struct OffsetModifier: ViewModifier {
	
	var tab: Tab
	@Binding var currentTab: String
	
	func body(content: Content) -> some View {
		content
			.overlay(
				// Getting Scroll Offset using Geometry Reader..
				GeometryReader { proxy in
					Color.clear
						.preference(key: OffsetKey.self, value: proxy.frame(in: .named("SCROLL")))
				}
			)
			.onPreferenceChange(OffsetKey.self) { proxy in
				// print(proxy.minY)
				
				// if minY is between 20 to -half of the midX
				// then updating current tab..
				
				// Since on chnage on Content is updating Scroll..
				// to avoid that..
				
				// Adding "SCROLL" to last of ID..
				// To identify Easily..
				
				let offset = proxy.minY
				withAnimation(.easeInOut) {
					currentTab = (offset < 20  && -offset < (proxy.midX / 2) && currentTab != tab.id) ? "\(tab.id) SCROLL" : currentTab
				}
			}
	}
}

struct OffsetModifier_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


// Preference Key..
struct OffsetKey: PreferenceKey {
	
	static var defaultValue: CGRect = .zero
	
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}
