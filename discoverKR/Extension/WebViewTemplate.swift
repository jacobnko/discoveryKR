

import SwiftUI
import WebKit


struct WebViewTemplate: UIViewRepresentable {
	var urlToLoad: String
	
	// UI View 만들기
	func makeUIView(context: Context) -> WKWebView {
		//unwrapping
		guard let url = URL(string: self.urlToLoad) else {
			return WKWebView()
		}
		// WebView instance 생성
		let webView = WKWebView()
		
		// WebView load
		webView.load(URLRequest(url: url))
		
		return webView
		
	}
	
	// Updated UIView
	func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebViewTemplate>) {
		
	}
}
