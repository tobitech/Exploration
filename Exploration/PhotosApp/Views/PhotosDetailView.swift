import SwiftUI

struct PhotosDetailView: View {
	@Environment(PhotoUICoordinator.self) private var coordinator
	
	var body: some View {
		VStack(spacing: 0) {
			NavigationBar()
			
			GeometryReader {
				let size = $0.size
				
				/// Here, the scrollview items take up the entire size, whereas the detail view contains a navigation bar that takes up some space.
				/// Let's modify the code to ensure the scrollview only takes up available space.
				ScrollView(.horizontal) {
					LazyHStack(spacing: 0) {
						ForEach(coordinator.items) { item in
							ImageView(item, size: size)
						}
					}
					.scrollTargetLayout()
				}
				/// Making it as a paging view.
				.scrollTargetBehavior(.paging)
				.scrollPosition(id: .init(
					get: { return coordinator.detailScrollPosition },
					set: { coordinator.detailScrollPosition = $0 })
				)
				.onChange(of: coordinator.detailScrollPosition, { oldValue, newValue in
					coordinator.didDetailPageChanged()
				})
				/// We can just add the destination anchor as a background to the scrollview, which likewise occupies the full available space, because every item in the destination scrollview takes up the entire available.
				.background {
					if let selectedItem = coordinator.selectedItem {
						Rectangle()
							.fill(.clear)
							.anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
								return [selectedItem.id + "DEST": anchor]
							})
					}
				}
			}
		}
		.opacity(coordinator.showDetailView ? 1 : 0)
		.onAppear {
			/// This will ensure that the detail view loads and initiates the layer animation.
			/// The reason it's not toggled when the item is tapped in Home View is that occasionally, the destination view might not be loaded. In that scenario, the destination anchor will be nil and the layer will not be animated.
			coordinator.toggleView(show: true)
		}
	}
	
	// Custom Navigation Bar
	@ViewBuilder
	func NavigationBar() -> some View {
		HStack {
			Button {
				coordinator.toggleView(show: false)
			} label: {
				HStack(spacing: 2) {
					Image(systemName: "chevron.left")
						.font(.title3)
					Text("Back")
				}
			}
			.tint(.primary)
			
			Spacer(minLength: 0)
			
			Button {
				coordinator.toggleView(show: false)
			} label: {
				Image(systemName: "ellipsis")
					.padding(10)
					.background(.bar, in: .circle)
			}
			.tint(.primary)
		}
		.padding([.top, .horizontal], 15)
		.padding(.bottom, 10)
		.background(.ultraThinMaterial)
		.offset(y: coordinator.showDetailView ? 0 : -120)
		.animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
	}
	
	@ViewBuilder
	func ImageView(_ item: TPhotoItem, size: CGSize) -> some View {
		if let image = item.image {
			Image(uiImage: image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: size.width, height: size.height)
				.clipped()
				.contentShape(.rect)
		}
	}
}

#Preview {
	PhotosAppContentView()
}
