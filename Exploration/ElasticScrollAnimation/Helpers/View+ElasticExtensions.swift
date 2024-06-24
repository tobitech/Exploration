import SwiftUI

// Custom View Modifiers
extension View {
	/// Enables Elastic Scroll
	/// Note: Needs to be added to each item view inside the scroll view.
	@ViewBuilder
	func elasticScroll(scrollRect: CGRect, screenSize: CGSize) -> some View {
		self
			.modifier(
				ElasticScrollHelper(
					scrollRect: scrollRect,
					screenSize: screenSize
				)
			)
	}
}

// Private helper for elastic scroll
fileprivate struct ElasticScrollHelper: ViewModifier {
	var scrollRect: CGRect
	var screenSize: CGSize
	
	// View Modifier Properties
	@State private var viewRect: CGRect = .zero
	
	func body(content: Content) -> some View {
		/// The logic here is that we're converting the scrollview offset into progress starting from zero and going to multiply the progress into the view's current minY, and thus it will move the current view further from its original place, thus creating an elastic effect.
		/// As you can see, the view is moving along with the elastic effect and is not in its initial position. Applying scrollview content offset (MinY) in the opposite direction multiplied by the progress we just made will solve this problem.
		let progress = scrollRect.minY / scrollRect.maxY
		/// If you need more elasticity then adjust it's multiplier
		let multiplier = 1.2 // also try 1.5 or 2.0
		let elasticOffset = (progress * viewRect.minY) * multiplier
		/// Bottom progress and bottom ElasticOffset
		/// To start from 0, simply remove 1 from the progress
		let bottomProgress = max(1 - (scrollRect.maxY / screenSize.height), 0)
		/// If you need more elasticity then adjust it's multiplier
		let bottomElasticOffset = (viewRect.maxY * bottomProgress) * 1
		content
		/// With this you can guess when the scroll view is overscrolling by comparing scrollview's maxY with screen size height.
			// .overlay {
				// Text("\(bottomProgress)")
				// Text("\(Int(scrollRect.maxY))" + " \(Int(screenSize.height))")
					// .offset(x: 50)
			// }
			.offset(y: scrollRect.minY > 0 ? elasticOffset : 0)
			.offset(y: scrollRect.minY > 0 ? -(progress * scrollRect.minY * multiplier) : 0)
			.offset(y: scrollRect.maxY < screenSize.height ? bottomElasticOffset : 0)
			/// Add this modifier as well if you need to move the bottom view alongside the scroll view.
			// .offset(y: scrollRect.maxY < screenSize.height ? -(bottomProgress * scrollRect.maxY) : 0)
			.offsetExtractor(coordinateSpace: "SCROLLVIEW") {
				viewRect = $0
			}
	}
}

#Preview {
	ElasticScrollContentView()
}
