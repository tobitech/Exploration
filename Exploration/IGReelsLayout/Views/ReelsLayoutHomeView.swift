import SwiftUI

struct ReelsLayoutHomeView: View {
	var size: CGSize
	var safeArea: EdgeInsets
	
	// View Properties
	@State private var reels: [IGReel] = reelsData
	@State private var likedCounter: [Like] = []
	
	var body: some View {
		ScrollView(.vertical) {
			LazyVStack(spacing: 0) {
				ForEach($reels) { reel in
					ReelView(
						reel: reel,
						likedCounter: $likedCounter,
						size: size,
						safeArea: safeArea
					)
					.frame(maxWidth: .infinity)
					.containerRelativeFrame(.vertical)
				}
			}
		}
		.scrollIndicators(.hidden)
		.scrollTargetBehavior(.paging)
		.background(.black)
		// Like Animation View
		.overlay(alignment: .topLeading) {
			ZStack {
				ForEach(likedCounter) { like in
					Image(systemName: "suit.heart.fill")
						.font(.system(size: 75))
						.foregroundStyle(.red.gradient)
						/// The view isn't aligned at the center of the tap position. This is because since the view is moved from the top left position. In order to make it center, we need to remove half the width and half the height from the offset.
						.frame(width: 100, height: 100)
						// Adding some implicit rotation and scaling.
						.animation(.smooth, body: { view in
							view.scaleEffect(like.isAnimated ? 1 : 1.8)
								.rotationEffect(.init(degrees: like.isAnimated ? 0 : .random(in: -30...30)))
						})
						.offset(x: like.tappedRect.x - 50, y: like.tappedRect.y - 50)
						// Let's Animate
						.offset(y: like.isAnimated ? -(like.tappedRect.y + safeArea.top) : 0)
				}
			}
		}
		.overlay(alignment: .top) {
			Text("Reels")
				.font(.title3)
				.fontWeight(.semibold)
				.frame(maxWidth: .infinity)
				.overlay(alignment: .trailing) {
					Button("", systemImage: "camera") {
						
					}
					.font(.title2)
				}
				.foregroundStyle(.white)
				.padding(.top, safeArea.top + 15)
				.padding(.horizontal, 15)
		}
		.environment(\.colorScheme, .dark)
	}
}

#Preview {
	ReelsLayoutContentView()
}
