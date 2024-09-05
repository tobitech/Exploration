import SwiftUI

// Config
struct PopConfig {
	var backgroundColor: Color = .black.opacity(0.25)
	/// You can add extra properties here if you wish to.
}

// Custom Modifier
extension View {
	@ViewBuilder
	func popView<Content: View>(
		config: PopConfig = .init(),
		isPresented: Binding<Bool>,
		onDismiss: @escaping () -> Void,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.modifier(
				PopViewHelper(
					config: config,
					isPresented: isPresented,
					onDismiss: onDismiss,
					viewContent: content
				)
			)
	}
}

/// To implement our custom animation, we must first remove the default full-screen cover scroll animation. We can do this simply by using SwiftUl Transactions.
/// The animation choice is a personal preference.You can fade in/out and move the view in any direction, but I chose to move it from the bottom with a fading background.
/// For the commented out line inside the visualEffect modifier: We might get an error that call of main actor-isolated function inside a non-isolated context warning etc.
/// And here is how we can fix it.
/// Since we're capturing mutable screenSize and animateView inside the visualEffect closure, this warning (future error) arises. There are two ways to solve this warning: One to make these values immutable (let) values or to capture these values in the closure call, like this "{ [screenSize, animateView] content, proxy in"
/// This will capture these values as let, confirming that these values might not change in any other threads.
fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
	var config: PopConfig
	@Binding var isPresented: Bool
	var onDismiss: () -> Void
	@ViewBuilder var viewContent: ViewContent
	
	// Local View Properties
	@State private var presentFullScreenCover: Bool = false
	@State private var animateView: Bool = false
	
	func body(content: Content) -> some View {
		// Unmutable properties:
		let screenHeight = screenSize.height
		let animateView = animateView
		
		content
		/// I'm not going to create any custom controller to create this effect. I'm going to customise this native fullScreenCover modifier to achieve this effect.
			.fullScreenCover(
				isPresented: $presentFullScreenCover,
				onDismiss: onDismiss
			) {
				ZStack {
					Rectangle()
						.fill(config.backgroundColor)
						.ignoresSafeArea()
						.opacity(animateView ? 1 : 0)
					
					viewContent
						.visualEffect { content, geometryProxy in
							content
							// this is the line that might throw the main actor-isolated warning
							// .offset(y: offset(geometryProxy))
								.offset(y: offset(geometryProxy, screenHeight: screenHeight, animateView: animateView))
						}
						.presentationBackground(.clear)
						.task {
							guard !animateView else { return }
							withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
								self.animateView = true
							}
						}
						.ignoresSafeArea(.container, edges: .all)
				}
			}
			.onChange(of: isPresented) { oldValue, newValue in
				if newValue {
					toggleView(true)
				} else {
					// Let's close this popup with animation, and once the animation is finished, let's remove this full-screen cover without any animations.
					Task {
						withAnimation(.snappy(duration: 0.45, extraBounce: 0)) {
							self.animateView = false
						}
						
						/// Instead of Task.sleep - you can also use the withAnimation completion property.
						try? await Task.sleep(for: .seconds(0.45))
						toggleView(false)
					}
				}
			}
	}
	
	func toggleView(_ status: Bool) {
		var transaction = Transaction()
		transaction.disablesAnimations = true
		withTransaction(transaction) {
			presentFullScreenCover = status
		}
	}
	
	nonisolated func offset(_ proxy: GeometryProxy, screenHeight: CGFloat, animateView: Bool) -> CGFloat {
		let viewHeight = proxy.size.height
		return animateView ? 0 : (screenHeight + viewHeight) / 2
	}
	
	// Old approach throwing main actor-isolated warning.
//	func offset(_ proxy: GeometryProxy) -> CGFloat {
//		let viewHeight = proxy.size.height
//		if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
//			/// This will position the view exactly at the bottom of the screen and move it up to the center when animated.
//			return animateView ? 0 : (viewHeight + screenSize.height) / 2
//		}
//		return 0
//	}
	
	var screenSize: CGSize {
		if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
			/// This will position the view exactly at the bottom of the screen and move it up to the center when animated.
			return screenSize
		}
		
		return .zero
	}
}

#Preview {
	PopContentView()
}
