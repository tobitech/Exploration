import SwiftUI

/// Instead of using an overlay for these animation effects, let's use a full-screen cover. This way, the morphing menu tray can be used inside any view, resulting in the same behaviour.
///
/// So, essentially, l've removed the full-screen cover sliding animation by using the Transaction() method. This simply adds the view on top of the view immediately without any animations. Now, we need to position the source button at the exact location. To do that, let's use the onGeometryChange method to read the geometry values of the view!
///
/// Alright, let's transform the label into a menu-view with some spring animations. We'll also place the menu-view at the bottom when it's expanded. So, when the source-button is clicked, it will morph into a menu that will be placed at the bottom.
///
/// As you can notice, the animations are not uniform. To solve this, we can simply use the geometryGroup() modifier. So, what this modifier does is that by default, SwiftUl animates all the leaf views individually, but when using this modifier, it kind of groups the views and applies the animation to the grouped view rather than animating all the leaf views individually!
///
/// Now, let's add a background for tapping. When tapped, the menu will morph back to its original source view and remove the full-screen cover once the animation completes!
///
/// Finally, let's transform the menu into a full-screen view whenever the "showExpandedContent" is toggled!
///
/// As I said before, since this is using full-screen-cover to do the animation effects, this will work inside any view. Now let's test this with a List and placed under a section!
struct MorphingButton<Label: View, Content: View, ExpandedContent: View>: View {
	var backgroundColor: Color
	@Binding var showExpandedContent: Bool
	
	@ViewBuilder var label: Label
	@ViewBuilder var content: Content
	@ViewBuilder var expandedContent: ExpandedContent
	
	// View Properties
	@State private var showFullScreenCover: Bool = false
	@State private var animateContent: Bool = false
	@State private var viewPosition: CGRect = .zero
	
	var body: some View {
		label
			.background(backgroundColor)
			.clipShape(.circle)
			.contentShape(.circle)
			.onGeometryChange(for: CGRect.self, of: {
				$0.frame(in: .global)
			}, action: { newValue in
				viewPosition = newValue
			})
			.opacity(showFullScreenCover ? 0 : 1)
			.onTapGesture {
				toggleFullScreenCover(false, status: true)
			}
			.fullScreenCover(isPresented: $showFullScreenCover) {
				ZStack(alignment: .topLeading) {
					if animateContent {
						ZStack(alignment: .top) {
							if showExpandedContent {
								expandedContent
									.transition(.blurReplace)
							} else {
								content
									.transition(.blurReplace)
							}
						}
						.transition(.blurReplace)
					} else {
						label
							.transition(.blurReplace)
					}
				}
				.geometryGroup()
				.clipShape(.rect(cornerRadius: 30, style: .continuous))
				.background {
					RoundedRectangle(cornerRadius: 30, style: .continuous)
						.fill(backgroundColor)
						.ignoresSafeArea()
				}
				.presentationBackground(.clear)
				.padding(.horizontal, animateContent && !showExpandedContent ? 15 : 0)
				.padding(.bottom, animateContent && !showExpandedContent ? 5 : 0)
				.frame(
					maxWidth: .infinity,
					maxHeight: .infinity,
					alignment: animateContent ? .bottom : .topLeading
				)
				.offset(
					x: animateContent ? 0 : viewPosition.minX,
					y: animateContent ? 0 : viewPosition.minY
				)
				.ignoresSafeArea(animateContent ? [] : .all)
				.background {
					Rectangle()
						.fill(.black.opacity(animateContent ? 0.05 : 0))
						.ignoresSafeArea()
						.onTapGesture {
							withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0), completionCriteria: .removed) {
								animateContent = false
							} completion: {
								// Removing sheet after a little delay.
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
									toggleFullScreenCover(false, status: false)
								}
							}
						}
				}
				.task {
					try? await Task.sleep(for: .seconds(0.05))
					withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
						animateContent = true
					}
				}
				.animation(.interpolatingSpring(duration: 0.2, bounce: 0), value: showExpandedContent)
			}
	}
	
	private func toggleFullScreenCover(
		_ withAnimation: Bool,
		status: Bool
	) {
		var transaction = Transaction()
		transaction.disablesAnimations = !withAnimation
		
		withTransaction(transaction) {
			showFullScreenCover = status
		}
	}
}

#Preview {
	MorphingFABContentView()
}
