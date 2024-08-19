import SwiftUI

/// Now that the tab bar is completely hidden, let's start building
struct CustomTabBar: View {
	var activeForeground: Color = .white
	var activeBackground: Color = .blue
	@Binding var activeTab: FloatingTab
	/// For Matched Geometry Effect.
	@Namespace private var animation
	
	// View Properties
	@State private var tabLocation: CGRect = .zero
	
	var body: some View {
		let status = activeTab == .home || activeTab == .search
		
		HStack(spacing: !status ? 0 : 12) {
			HStack(spacing: 0) {
				ForEach(FloatingTab.allCases, id: \.rawValue) { tab in
					Button {
						activeTab = tab
					} label: {
						HStack(spacing: 5) {
							Image(systemName: tab.rawValue)
								.font(.title3)
								.frame(width: 30, height: 30)
							
							if activeTab == tab {
								Text(tab.title)
									.font(.footnote.weight(.semibold))
									.lineLimit(1)
							}
						}
						.foregroundStyle(activeTab == tab ? activeForeground : .secondary)
						.padding(.vertical, 2)
						.padding(.leading, 10)
						.padding(.trailing, 15)
						.contentShape(.rect)
						.background {
							if activeTab == tab {
								Capsule()
									.fill(activeBackground.gradient) // remove this for the bottom line
								// .fill(.clear) // Restore this back
								/// It's fine, but you'll notice a slight fade in/out effect while switching from one tab to another.
								/// Let's remove that effect using the new onGeometryChange modifier.
								//								.onGeometryChange(for: CGRect.self, of: {
								//									$0.frame(in: .named("TABBARVIEW"))
								//								}, action: { newValue in
								//									tabLocation = newValue
								//								})
									.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
							}
						}
					}
					.buttonStyle(.plain)
				}
			}
			.background(alignment: .leading) {
				/// So, when the tab is changed via matchedGeometryEffect, which means the view positions shift from one place to another, I simply use the onGeometryChange modifier to capture the updated position of the tab indicator and use that value to create a custom indicator, which will make the indicator transition smoothly without any fade-in/out effect.
				Capsule()
					.fill(activeBackground.gradient)
					.frame(width: tabLocation.width, height: tabLocation.height)
					.offset(x: tabLocation.minX)
			}
			.coordinateSpace(.named("TABBARVIEW"))
			.padding(.horizontal, 5)
			.frame(height: 45)
			.background(
				.background
					.shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
					.shadow(.drop(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)),
				in: .capsule
			)
			.zIndex(10)
			
			Button {
				if activeTab == .home {
					print("Profile")
				} else {
					print("Microphone Search")
				}
			} label: {
				MorphingSymbolView(
					symbol: activeTab == .home ? "person.fill" : "mic.fill",
					config: .init(
						font: .title3,
						frame: .init(width: 42, height: 42),
						radius: 2,
						foregroundColor: activeForeground,
						keyFrameDuration: 0.3,
						symbolAnimation: .smooth(duration: 0.3, extraBounce: 0)
					)
				)
				.background(activeBackground.gradient)
				.clipShape(.circle)
//				Image(systemName: activeTab == .home ? "person.fill" : "slider.vertical.3")
//					.font(.title3)
//					.frame(width: 42, height: 42)
//					.foregroundStyle(activeForeground)
			}
			.buttonStyle(.plain)
			.allowsHitTesting(status)
			.offset(x: status ? 0 : -20)
			.padding(.leading, status ? 0 : -42)
		}
		.padding(.bottom, 5)
		.animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
	}
}

#Preview {
	FloatingTabsContentView()
}
