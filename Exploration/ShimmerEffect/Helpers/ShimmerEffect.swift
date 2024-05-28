import SwiftUI

// Shimmer Effect Custom View Modifier
extension View {
	@ViewBuilder
	func shimmer(_ config: ShimmerConfig) -> some View {
		self
			.modifier(ShimmerEffect(config: config))
	}
}

fileprivate struct ShimmerEffect: ViewModifier {
	// Shimmer Config
	var config: ShimmerConfig
	
	// Animation Properties
	@State private var moveTo: CGFloat = -0.7
	
	func body(content: Content) -> some View {
		content
		// Adding Shimmer Animation with the help of masking modifier.
		// Hiding the normal one and adding the shimmer one instead
			.hidden()
			.overlay {
				// Changing tint color
				Rectangle()
					.fill(config.tint)
					.mask {
						content
					}
					.overlay {
						// Shimmer
						GeometryReader {
							let size = $0.size
							/// In smaller views The shimmer mask is starting sooner than in larger views; that's why the animation is not completing properly. To avoid this, move the view a little bit based on the view's height.
							let extraOffset = size.height / 2
							
							Rectangle()
								.fill(config.highlight)
								.mask {
									Rectangle()
									// Gradient for glowing at the center
										.fill(.linearGradient(colors: [
											.white.opacity(0),
											config.highlight.opacity(config.highlightOpacity),
											.white.opacity(0)
										], startPoint: .top, endPoint: .bottom)
										)
									// Adding blur
										.blur(radius: config.blur)
									// Rotating (Degree: Your choice of wish
										.rotationEffect(.init(degrees: -70))
									// Moving to the start
										.offset(x: moveTo > 0 ? extraOffset : -extraOffset)
										.offset(x: size.width * moveTo)
								}
							/// You can add another property in the config for blend mode and use it after the mask if you need more customisation e.g. mask {}.blendMode()
						}
						// mask with the content
						.mask {
							content
						}
					}
				// Animating movement
					.onAppear {
						/// Sometimes a forever animation called inside onAppear will cause animation glitches, especially when using inside NavigationView; to avoid that simply wrap it inside DispatchQueue.
						DispatchQueue.main.async {
							moveTo = 0.7
						}
					}
					.animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
			}
	}
}

// Shimmer Config: Contains all shimmer animation properties
struct ShimmerConfig {
	var tint: Color
	var highlight: Color
	var blur: CGFloat = 0
	var highlightOpacity: CGFloat = 1
	var speed: CGFloat = 2
}

#Preview {
	ShimmerEffectContentView()
}
