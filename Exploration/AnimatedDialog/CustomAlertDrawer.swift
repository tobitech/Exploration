import SwiftUI

// Custom Alert Drawer Overlay view
/// Attach the overlay to the root view to achieve the desired animation effect.
/// However, keep in mind that every button and overlay requires individual configurations.
/// Therefore, don't create multiple buttons with the same configuration.
/// Also, note that this is a custom overlay that will put the view on top of the sheet's or fullscreen cover!
extension View {
	@ViewBuilder
	func alertDrawer<Content: View>(
		config: Binding<DrawerConfig>,
		primaryTitle: String,
		secondaryTitle: String,
		/// Let's modify the callbacks to return a boolean value instead of Void.
		/// When the boolean value is true, the drawer should automatically get dismissed!
		onPrimaryClick: @escaping () -> Bool, // () -> Void
		onSecondaryClick: @escaping () -> Bool, // () -> Void
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.overlay {
				/// My objective is to animate the drawer from its initial position, which is the Source Button, to the bottom of the screen.
				/// To accomplish this, we require information about the screen's frame rect, and that's why I wrapped the ZStack of the custom overlay view inside a GeometryReader so that we can extract the required details!
				GeometryReader { geometry in
					let isPresented = config.wrappedValue.isPresented

					ZStack {
						if isPresented {
							Rectangle()
								.fill(.black.opacity(0.5))
								.transition(.opacity)
								.onTapGesture {
									// prevent multiple taps
									guard config.wrappedValue.isPresented else { return }
									
									withAnimation(
										config.wrappedValue.animation,
										completionCriteria: .logicallyComplete
									) {
										config.wrappedValue.isPresented = false
									} completion: {
										config.wrappedValue.hideSourceButton = false
									}
								}
						}
						
						/// As you can observe, the drawer has successfully transitioned from its source to the bottom of the screen.Now, let's position the actions button at its source position initially. When it's animating, we'll move it to its default position. By doing this, we'll create an effect similar to a hero effect, where the button transitions from the source view to the destination view.
						if config.wrappedValue.hideSourceButton {
							AlertDrawerContent(
								proxy: geometry,
								primaryTitle: primaryTitle,
								secondaryTitle: secondaryTitle,
								onPrimaryClick: onPrimaryClick,
								onSecondaryClick: onSecondaryClick,
								config: config,
								content: content
							)
							.transition(.identity)
							/// The property "hideSourceButton" not only used to hide the source button but also to insert or remove the drawer view from the context.
							/// The reason for the "topLeading" alignment is that iOS uses a coordinate system from the top-left, and we're positioning the drawer using offsets.
							/// This ensures that it works perfectly as intended.
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
						}
					}
					.ignoresSafeArea()
				}
			}
	}
}

/// My objective is to animate the drawer from its initial position, which is the Source Button, to the bottom of the screen.
/// To accomplish this, we require information about the screen's frame rect, and that's why I wrapped the ZStack of the custom overlay view inside a GeometryReader so that we can extract the required details!
fileprivate struct AlertDrawerContent<Content: View>: View {
	var proxy: GeometryProxy
	var primaryTitle: String
	var secondaryTitle: String
	var onPrimaryClick: () -> Bool
	var onSecondaryClick: () -> Bool
	@Binding var config: DrawerConfig
	@ViewBuilder var content: Content
	
	var body: some View {
		let isPresented = config.isPresented
		let sourceRect = config.sourceRect
		let maxY = proxy.frame(in: .global).maxY
		let bottomPadding: CGFloat = 10
		
		VStack(spacing: 15) {
			content
				// Close button
				.overlay(alignment: .topTrailing) {
					Button {
						dismissDrawer()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title2)
							.foregroundStyle(Color.primary, .gray.opacity(0.15))
					}
				}
				.compositingGroup()
				.opacity(isPresented ? 1 : 0)
			
			// Actions
			HStack(spacing: 10) {
				GeometryReader { geometry in
					Button(
						action: {
							if onSecondaryClick() {
								dismissDrawer()
							}
						},
						label: {
							Text(secondaryTitle)
								.fontWeight(.semibold)
								.foregroundStyle(Color.primary)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(.ultraThinMaterial, in: config.clipShape)
						}
					)
					.offset(fixedLocation(geometry))
					.opacity(isPresented ? 1 : 0)
				}
				.frame(height: config.sourceRect.height)
				
				GeometryReader { geometry in
					Button(
						action: {
							if onPrimaryClick() {
								dismissDrawer()
							}
						},
						label: {
							Text(primaryTitle)
								.fontWeight(.semibold)
								.foregroundStyle(config.foreground)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(config.tint, in: config.clipShape)
						}
					)
					/// Let's make the Primary button take the exact same size as the source button at the initial state. Then, while animating, we can revert to its actual size.
					.frame(
						width: isPresented ? nil : sourceRect.width,
						height: isPresented ? nil : sourceRect.height
					)
					.offset(fixedLocation(geometry))
				}
				.frame(height: config.sourceRect.height)
				// Placing this view above the cancel button!
				.zIndex(1)
			}
			.buttonStyle(ScaledButtonStyle())
			.padding(.top, 10)
		}
		.padding([.horizontal, .top], 20)
		.padding(.bottom, 15)
		.frame(
			width: isPresented ? nil : sourceRect.width,
			height: isPresented ? nil : sourceRect.height,
			alignment: .top
		)
		.background(.background)
		.clipShape(.rect(cornerRadius: sourceRect.height / 2))
		// Optional shadows
		.shadow(color: .black.opacity(isPresented ? 0.1 : 0), radius: 5, x: 5, y: 5)
		.shadow(color: .black.opacity(isPresented ? 0.1 : 0), radius: 5, x: -5, y: -5)
		.padding(.horizontal, isPresented ? 20 : 0)
		.visualEffect { content, proxy in
			content
				.offset(
					x: isPresented ? 0 : sourceRect.minX,
					y: (isPresented ? maxY - bottomPadding : sourceRect.maxY) - proxy.size.height
				)
		}
		.allowsHitTesting(config.isPresented)
	}
	
	private func dismissDrawer() {
		withAnimation(config.animation, completionCriteria: .logicallyComplete) {
			config.isPresented = false
		} completion: {
			config.hideSourceButton = false
		}

	}
	
	func fixedLocation(_ proxy: GeometryProxy) -> CGSize {
		let isPresented = config.isPresented
		let sourceRect = config.sourceRect

		return CGSize(
			width: isPresented ? 0 : (sourceRect.minX - proxy.frame(in: .global).minX),
			height: isPresented ? 0 : (sourceRect.minY - proxy.frame(in: .global).minY)
		)
	}
}

#Preview {
	AnimatedDialogContentView()
}
