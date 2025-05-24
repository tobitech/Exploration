import SwiftUI

// Acts as a wrapper to the show menu view on top of the wrapped view
struct CustomMenuView<Content: View>: View {
	@Binding var config: MenuConfig
	@ViewBuilder var content: Content
	@MenuActionBuilder var actions: [MenuAction]
	
	// View Properties
	@State private var animateContent: Bool = false
	@State private var animateLabels: Bool = false
	// For resetting scroll position, once the menu is closed!
	@State private var activeActionID: String?

	var body: some View {
		content
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.overlay {
				// Blurred Overlay
				Rectangle()
					.fill(.bar)
					.ignoresSafeArea()
					.opacity(animateContent ? 1 : 0)
					.allowsHitTesting(false)
			}
			.overlay {
				if animateContent {
					// Instead of using withAnimation completion callback,
					// We are using onDisappear modifier to know when the animation gets completed
					Rectangle()
						.foregroundStyle(.clear)
					// Disable user interaction until menu view gets closed completely!
						.contentShape(.rect)
						.onDisappear {
							config.hideSourceView = false
							activeActionID = actions.first?.id
						}
				}
			}
			.overlay {
				GeometryReader {
					MenuScrollView($0)
					
					/// Finally, let us utilize the source view we saved in the config to place at the same position as the source button. When expanding it, it should scale larger with a subtle blur and opacity effect.
					if config.hideSourceView {
						config.sourceView
							.scaleEffect(animateContent ? 15 : 1, anchor: .bottom)
							.offset(x: config.sourceLocation.minX, y: config.sourceLocation.minY)
							.opacity(animateContent ? 0.25 : 1)
							.blur(radius: animateContent ? 130 : 0)
							.ignoresSafeArea()
							.allowsHitTesting(false)
					}
				}
				.opacity(config.hideSourceView ? 1 : 0)
			}
			.onChange(of: config.showMenu) { oldValue, newValue in
				if newValue {
					config.hideSourceView = true
				}

				withAnimation(.smooth(duration: 0.45, extraBounce: 0)) {
					animateContent = newValue
				}
				
				/// Now, let's give these titles distinct animations compared to the icons. For instance, when expanding the title, it should take longer to reveal, while dismissing the title texts should be gone swiftly, unlike the icons.
				withAnimation(.easeInOut(duration: newValue ? 0.35 : 0.15)) {
					animateLabels = newValue
				}
			}
	}
	
	// Menu ScrollView
	@ViewBuilder
	func MenuScrollView(_ proxy: GeometryProxy) -> some View {
		ScrollView(.vertical) {
			VStack(alignment: .leading, spacing: 0) {
				ForEach(actions) {
					MenuActionView($0)
				}
			}
			.scrollTargetLayout()
			.padding(.horizontal, 25)
			.frame(maxWidth: .infinity, alignment: .leading)
			// For background tap to dismiss the menu view
			.background {
				Rectangle()
					.foregroundStyle(.clear)
					.frame(width: proxy.size.width, height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom)
					.contentShape(.rect)
					.onTapGesture {
						guard config.showMenu else { return }
						config.showMenu = false
					}
				// Sticking to the top
					.visualEffect { content, proxy in
						content
							.offset(
								x: -proxy.frame(in: .global).minX,
								y: -proxy.frame(in: .global).minY
							)
					}
			}
		}
		.safeAreaPadding(.vertical, 20)
		// Making it start at the center.
		.safeAreaPadding(.top, (proxy.size.height - 70) / 2)
		.scrollPosition(id: $activeActionID, anchor: .top)
		.scrollIndicators(.hidden)
		.allowsHitTesting(config.showMenu)
	}
	
	// Menu Action View
	@ViewBuilder
	func MenuActionView(_ action: MenuAction) -> some View {
		let sourceLocation = config.sourceLocation
		
		HStack(spacing: 20) {
			Image(systemName: action.symbolImage)
				.font(.title3)
				.frame(width: 40, height: 40)
				.background {
					Circle()
						.fill(.background)
						.shadow(radius: 1.5)
				}
				.scaleEffect(animateContent ? 1 : 0.6)
				.opacity(animateContent ? 1 : 0)
				.blur(radius: animateContent ? 0 : 4)
			
			Text(action.text)
				.font(.system(size: 19))
				.fontWeight(.medium)
				.lineLimit(1)
				.opacity(animateLabels ? 1 : 0)
				.blur(radius: animateLabels ? 0 : 4)
		}
		/// Now, let's utilize the visual Effect modifier to position all the menu actions at the same location as the source menu button. When expanding the menu, these actions will move to their respective locations.
		/// Furthermore, we can apply scaling and blur effects to mimic the expansion of these menu actions from the source menu button. This will create an effect reminiscent of the iMessage menu animation!
		.visualEffect({[animateContent] content, proxy in
			content
			// Making all the actions to be placed at the source button location
				.offset(
					x: animateContent ? 0 : sourceLocation.minX - proxy.frame(in: .global).minX,
					y: animateContent ? 0 : sourceLocation.minY - proxy.frame(in: .global).minY
				)
		})
		.frame(height: 70)
		.contentShape(.rect)
		.onTapGesture {
			action.action()
		}
	}
}

// Customised Source Button
struct MenuSourceButton<Content: View>: View {
	@Binding var config: MenuConfig
	@ViewBuilder var content: Content
	// For more user customisation!
	var onTap: () -> Void
	var body: some View {
		content
			.contentShape(.rect)
			.onTapGesture {
				onTap()
				config.sourceView = .init(content)
				config.showMenu.toggle()
			}
		// Saving source location
			.onGeometryChange(for: CGRect.self) {
				$0.frame(in: .global)
			} action: { newValue in
				config.sourceLocation = newValue
			}
		// Hiding source view hideSourceView is enabled.
			.opacity(config.hideSourceView ? 0.01 : 1)
	}
}

#Preview {
	iMessageMenuContentView()
}

// Menu Config
struct MenuConfig {
	var symbolImage: String
	var sourceLocation: CGRect = .zero
	var showMenu: Bool = false
	// Storing source view (Label) for scaling effect
	var sourceView: AnyView = .init(EmptyView())
	var hideSourceView: Bool = false
}

// Menu Action & Action Builder
struct MenuAction: Identifiable {
	private(set) var id: String = UUID().uuidString
	var symbolImage: String
	var text: String
	var action: () -> Void = {}
}

@resultBuilder
struct MenuActionBuilder {
	static func buildBlock(_ components: MenuAction...) -> [MenuAction] {
		components.compactMap { $0 }
	}
}
