import SwiftUI

// Page Indicator's View for Infinite Carousel.
// As of now, we don't have any native method to use page control separately rather than having it merged inside PageTabView.
struct PageControl: UIViewRepresentable {
	// Page Properties
	var totalPages: Int
	var currentPage: Int
	
	func makeUIView(context: Context) -> UIPageControl {
		let control = UIPageControl()
		control.numberOfPages = totalPages
		control.currentPage = currentPage
		control.backgroundStyle = .prominent
		control.allowsContinuousInteraction = false
		
		return control
	}
	
	func updateUIView(_ uiView: UIPageControl, context: Context) {
		uiView.numberOfPages = totalPages
		uiView.currentPage = currentPage
	}
}
