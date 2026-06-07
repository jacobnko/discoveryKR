import SwiftUI


extension View {
	
	// MARK: -  Vertical Center
	func vCenter() -> some View {
		self.frame(maxHeight: .infinity, alignment: .center)
	}
	
	// MARK: -  Vertical Top
	func vTop() -> some View {
		self.frame(maxHeight: .infinity, alignment: .top)
	}
	
	// MARK: -  Vertical Bottom
	func vBottom() -> some View {
		self.frame(maxHeight: .infinity, alignment: .bottom)
	}
	
	// MARK: -  Horizontal Center
	func hCenter() -> some View {
		self.frame(maxWidth: .infinity, alignment: .center)
	}
	
	// MARK: -  Horizontal Leading
	func hLeading() -> some View {
		self.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	// MARK: -  Horizontal Trailing
	func hTrailing() -> some View {
		self.frame(maxWidth: .infinity, alignment: .trailing)
	}
	
	// MARK: -  Responsive Size
	func getReact() -> CGRect {
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds
			?? CGRect(x: 0, y: 0, width: 390, height: 844)
	}
	
	// MARK: -  Get safeArea
	func getSafeArea() -> UIEdgeInsets {
		guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
			return .zero
		}
		
		guard let safeArea = screen.windows.first?.safeAreaInsets else {
			return .zero
		}
		return safeArea
	}
}
