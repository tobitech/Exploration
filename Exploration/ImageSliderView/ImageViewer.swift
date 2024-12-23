import SwiftUI

struct ImageViewer<Content: View>: View {
	// Config
	var config = ImageSliderConfig()
	@ViewBuilder var content: Content
	
	// View Properties
	@State private var isPresented: Bool = false
	@State private var activeTabID: Subview.ID?
	@State private var transitionSource: Int = 0
	@Namespace private var animation
	
	var body: some View {
		Group(subviews: content) { collection in
			// Going to use new iOS 18 APIs to retrieve the Subview collection from the given view content
			LazyVGrid(
				columns: Array(
					repeating: GridItem(
						spacing: config.spacing
					),
					count: 2
				),
				spacing: config.spacing,
				content: {
					/// Only displaying the first four images, and the remaining ones showing a count (like +4) at the fourth image,
					/// similar to Twitter app
					let remainingCount = max(collection.count - 4, 0)
					ForEach(collection.prefix(4)) { item in
						let index = collection.index(item.id)
						GeometryReader {
							let size = $0.size
							
							item
								.aspectRatio(contentMode: .fill)
								.frame(width: size.width, height: size.height)
								.clipShape(.rect(cornerRadius: config.cornerRadius))
							if collection.prefix(4).last?.id == item.id && remainingCount > 0 {
								RoundedRectangle(cornerRadius: config.cornerRadius)
									.fill(.black.opacity(0.35))
									.overlay {
										Text("+\(remainingCount)")
											.font(.largeTitle.weight(.semibold))
											.foregroundStyle(.white)
									}
							}
						}
						.frame(height: config.height)
						.frame(maxWidth: .infinity)
						.onTapGesture {
							/// For opening the selected image in the detail tab view.
							activeTabID = item.id
							/// For opening navigation detail view
							isPresented = true
							/// For zooming transition
							transitionSource = index
						}
						.matchedTransitionSource(id: index, in: animation) { configuration in
							configuration.clipShape(.rect(cornerRadius: config.cornerRadius))
						}
					}
				}
			)
			.navigationDestination(isPresented: $isPresented) {
				TabView(selection: $activeTabID) {
					ForEach(collection) { item in
						item
							.aspectRatio(contentMode: .fit)
							.tag(item.id)
					}
				}
				.tabViewStyle(.page)
				.background {
					Rectangle()
						.fill(.black)
						.ignoresSafeArea()
				}
				.navigationTransition(.zoom(sourceID: transitionSource, in: animation))
				// Hiding tool bar
				.toolbarVisibility(.hidden, for: .navigationBar)
				/// Updating transitionSource when tab item get changed
				.onChange(of: activeTabID) { oldValue, newValue in
					/// Consider this example: when the tab view at detail view is at index 6 or 7 and when it dismisses, the zoom transition won't have any effect because there's no matchedTransitionSource for that index. Therefore, indexes greater than 4 will always have a transition ID of 3
					transitionSource = min(collection.index(newValue), 3)
				}
			}
		}
	}
}

struct ImageSliderConfig {
	var height: CGFloat = 150
	var cornerRadius: CGFloat = 15
	var spacing: CGFloat = 10
}

#Preview {
	ImageSliderContentView()
}

extension SubviewsCollection {
	func index(_ id: SubviewsCollection.Element.ID?) -> Int {
		firstIndex(where: { $0.id == id }) ?? 0
	}
}
