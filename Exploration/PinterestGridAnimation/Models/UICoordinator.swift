import SwiftUI

@Observable
class UICoordinator {
	/// 1. We'll extract the SwiftUl scrollview and save it here to take a screenshot of the visible region for animation purposes.
	/// 2. Rect will be used to save the tapped post's View Rect for scaling calculations.
	// Shared View Properties between Home and Detail View
	var scrollView: UIScrollView = .init(frame: .zero)
	var rect: CGRect = .zero
	// Animation Layer Properties
	var animationLayer: UIImage?
	var animateView: Bool = false
	var hideLayer: Bool = false
	// Root View Properties
	var hideRootView: Bool = false
	
	func createVisibleAreaSnapshot() {
		let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
		let image = renderer.image { context in
			context.cgContext.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
			scrollView.layer.render(in: context.cgContext)
		}
		animationLayer = image
	}
}

/// This will extract the UlKit ScrollView from the SwiftUl ScrollView
struct ScrollViewExtractor: UIViewRepresentable {
	var result: (UIScrollView) -> Void
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .clear
		view.isUserInteractionEnabled = false
		
		DispatchQueue.main.async {
			if let scrollView = view.superview?.superview?.superview as? UIScrollView {
				result(scrollView)
			}
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) { }
}
