import SwiftUI

struct DetailView: View {
	@Environment(UICoordinator.self) private var coordinator
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let animateView = coordinator.animateView
			let hideLayer = coordinator.hideLayer
			let rect = coordinator.rect
			
			/// This sets the anchorX location of the scaling, if the anchor is less than 0.5, it is on the leading side, Otherwise, it is on the trailing side, Keep in mind that I am building this animation to support only two columns in a grid.
			let anchorX = (coordinator.rect.minX / size.width) > 0.5 ? 1.0 : 0.0
			// This value will be scaled to meet the screen's whole width.
			let scale = size.width / coordinator.rect.width
			
			/// The reason the expanded picture is not properly aligned with the screen is because of padding, We need to apply offset that corresponds with the provided padding, which means if a view horizontal padding 10 implies we need to shift the view 10 * scale. (Since the image has been resized.)
			// 15 - Horizontal padding
			let offsetX = animateView ? (anchorX > 0.5 ? 15 : -15) * scale : 0
			let offsetY = animateView ? -coordinator.rect.minY * scale : 0
			
			let detailHeight: CGFloat = rect.height * scale
			let scrollContentHeight: CGFloat = size.height - detailHeight
			
			if let image = coordinator.animationLayer,
					let post = coordinator.selectedItem {
				if !hideLayer {
					Image(uiImage: image)
						.scaleEffect(animateView ? scale : 1, anchor: .init(x: anchorX, y: 0))
						.offset(x: offsetX, y: offsetY)
						.offset(y: animateView ? -coordinator.headerOffset : 0)
						.opacity(animateView ? 0 : 1)
						.transition(.identity)
//						.onTapGesture {
//							// For testing
//							coordinator.animationLayer = nil
//							coordinator.hideRootView = false
//							coordinator.animateView = false
//						}
				}
				
				ScrollView(.vertical) {
					/// Because the hero view is disabled for user interaction, scrollview permits scrolling even when we drag it.
					ScrollContent()
						.safeAreaInset(edge: .top, spacing: 0) {
							Rectangle()
								.fill(.clear)
								.frame(height: detailHeight)
								.offsetY { offset in
									/// We don't want the header view to go all the way to the top because the scroll content may be bigger at times, so limiting it to merely stay at the top of the screen.
									coordinator.headerOffset = max(min(-offset, detailHeight), 0)
								}
						}
				}
				.scrollDisabled(!hideLayer)
				.contentMargins(.top, detailHeight, for: .scrollIndicators)
				.background {
					Rectangle()
						.fill(.background)
						.padding(.top, detailHeight)
				}
				/// We increased the scrollview's opacity and offset by up to 1.5X, however you can decrease it if you choose.
				.animation(.easeInOut(duration: 0.3).speed(1.5)) {
					$0
						.offset(y: animateView ? 0 : scrollContentHeight)
						.opacity(animateView ? 1 : 0)
				}
				
				/// As you can see, the edge pictures have been clipped because we just got a snapshot of the visible region. To fix this, we need to place a hero view at the exact source position (Grid) and extend it to meet the screen width. (Later, we may utilize this view as the detail view header and slide out when the detail view is scrolled.)
				// Hero Kinda View
				ImageView(post: post)
					.allowsHitTesting(false)
					.frame(
						width: animateView ? size.width : rect.width,
						height: animateView ? rect.height * scale : rect.height
					)
					.clipShape(.rect(cornerRadius: animateView ? 0 : 10))
					.overlay(alignment: .top) {
						HeaderActions(post)
						// Sticking the header actions to the top.
							.offset(y: coordinator.headerOffset)
							.padding(.top, safeArea.top)
					}
					.offset(x: animateView ? 0 : rect.minX, y: animateView ? 0 : rect.minY)
				/// As you can see, we must reverse the header offset when the detail view is closed, otherwise, the scaling will not be correctly aligned with the source view.
					.offset(y: animateView ? -coordinator.headerOffset : 0)
			}
		}
		.ignoresSafeArea()
	}
	
	// Scroll Content
	@ViewBuilder
	func ScrollContent() -> some View {
		// YOUR SCROLL CONTENT
		DummyContentView()
	}
	
	// Header Actions
	@ViewBuilder
	func HeaderActions(_ post: PGridItem) -> some View {
		HStack {
			Spacer(minLength: 0)
			Button {
				coordinator.toggleView(show: false, frame: .zero, post: post)
			} label: {
				Image(systemName: "xmark.circle.fill")
					.font(.title)
					.foregroundStyle(.primary, .bar)
					.padding(10)
					.contentShape(.rect)
			}
		}
		.animation(.easeInOut(duration: 0.3)) {
			$0
				.opacity(coordinator.hideLayer ? 1 : 0)
		}
		.tint(.primary)
	}
}

#Preview {
	GridAnimationContentView()
}
