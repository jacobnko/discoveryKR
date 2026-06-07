//
//  AboutView.swift
//  DiscoverKR
//
//  Created by Jacob Ko on 2022/02/28.
//

import SwiftUI

struct AboutView: View {
	// MARK: - Links (KTO English)
	private let links: [(image: String, url: String)] = [
		("Traveler-1", "https://english.visitkorea.or.kr/svc/whereToGo/locIntrdn/locIntrdnList.do?menuSn=216"),    // Tourist Attractions
		("Traveler-2", "https://english.visitkorea.or.kr/svc/contents/infoBscView.do?vcontsId=140665&menuSn=481"), // Transportation
		("Traveler-3", "https://english.visitkorea.or.kr/svc/contents/contentsView.do?vcontsId=140676"),           // Accommodation
		("Traveler-4", "https://english.visitkorea.or.kr/svc/sp/food"),                                            // Korean Food
		("Traveler-5", "https://english.visitkorea.or.kr/svc/thingsToDo/ShoppingLikeALocal/main.do?menuSn=639"),  // Shopping
	]

	// MARK: -  BODY
	var body: some View {
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 40) {
					BannerAd(unitID: AdMobConfig.bannerUnitID)

					ForEach(links, id: \.url) { item in
						NavigationLink(destination:
							WebViewTemplate(urlToLoad: item.url)
								.ignoresSafeArea(edges: .bottom)
						) {
							Image(item.image)
								.resizable()
								.scaledToFill()
								.frame(width: getReact().width * 0.9)
								.cornerRadius(20)
								.shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
						}
					}

					BannerAd(unitID: AdMobConfig.bannerUnitID)
				}
			}
			.navigationBarHidden(true)
		}
		.background(.ultraThickMaterial)
	}
}

// MARK: -  PREVIEW
struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
