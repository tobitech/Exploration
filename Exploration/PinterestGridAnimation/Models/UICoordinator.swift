import SwiftUI

@Observable
class UICoordinator {
	/// 1. We'll extract the SwiftUl scrollview and save it here to take a screenshot of the visible region for animation purposes.
	/// 2. Rect will be used to save the tapped post's View Rect for scaling calculations.
	// Shared View Properties between Home and Detail View
	var scrollView: UIScrollView = .init(frame: .zero)
	var rect: CGRect = .zero
	var selectedItem: PGridItem?
	// Animation Layer Properties
	var animationLayer: UIImage?
	var animateView: Bool = false
	var hideLayer: Bool = false
	// Root View Properties
	var hideRootView: Bool = false
	// Detail View Properties
	var headerOffset: CGFloat = .zero
	
	/// This will capture a screenshot of the scrollview's visible region, not the complete scroll content.
	func createVisibleAreaSnapshot() {
		let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
		let image = renderer.image { context in
			context.cgContext.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
			scrollView.layer.render(in: context.cgContext)
		}
		animationLayer = image
	}
	
	func toggleView(show: Bool, frame: CGRect, post: PGridItem) {
		if show {
			selectedItem = post
			// Store View's rect
			rect = frame
			// Generating ScrollView's visible area Snapshot.
			createVisibleAreaSnapshot()
			hideRootView = true
			// Animating View
			withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
				animateView = true
			} completion: {
				/// Once the detail view expands, we will hide the animation layer and enable detail view interaction (this will be reversed when the closing animation begins).
				self.hideLayer = true
			}
		} else {
			// Closing View
			hideLayer = false
			withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
				animateView = false
			} completion: {
				// Resetting Properties
				/// As you can see in the slow motion video, there is a white screen for just a split second, To fix this, wrap the resetProperties) in the DispatchQueue.
				DispatchQueue.main.async {
					self.resetAnimationProperties()
				}
			}
		}
	}
	
	private func resetAnimationProperties() {
		headerOffset = 0
		hideRootView = false
		/// Because this method is wrapped in the dispatch queue, certain negative values will appear in the detail view because the detail height was calculated using it, thus removing
		// rect = .zero - no longer needed.
		selectedItem = nil
		animationLayer = nil
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
