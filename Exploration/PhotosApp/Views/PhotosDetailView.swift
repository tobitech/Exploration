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
				.scrollIndicators(.hidden)
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
				.offset(coordinator.offset)
				
				Rectangle()
					.foregroundStyle(.clear)
					.frame(width: 10)
					.contentShape(.rect)
					.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								let translation = value.translation
								coordinator.offset = translation
								// Progress for fading out the Detail View
								/// You may also use width to compute progress and select the best option, but for the purposes of this video, I'm just using the height-based method.
								let heightProgress = max(min(translation.height / 200, 1), 0)
								coordinator.dragProgress = heightProgress
							}
							.onEnded { value in
								let translation = value.translation
								let velocity = value.velocity
								/// Similarly, you can also use the width value in the condition for dismissing the view, however we only used the height value.
								// let width = translation.width + (velocity.width / 5)
								let height = translation.height + (velocity.height / 5)
								
								if height > (size.height * 0.5) {
									// Close View
									coordinator.toggleView(show: false)
								} else {
									// Reset to Origin
									withAnimation(.easeInOut(duration: 0.2)) {
										coordinator.offset = .zero
										coordinator.dragProgress = 0
									}
								}
							}
					)
			}
			.opacity(coordinator.showDetailView ? 1 : 0)
			
			/// Now, using the drag progress value, we can simply fade out the detail view the background simultaneously moving the top and bottom view away as we start swiping.
			BottomIndicatorView()
				.offset(y: coordinator.showDetailView ? (120 * coordinator.dragProgress) : 120)
				.animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
		}
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
		/// Now, using the drag progress value, we can simply fade out the detail view the background simultaneously moving the top and bottom view away as we start swiping.
		.offset(y: coordinator.showDetailView ? (-120 * coordinator.dragProgress) : -120)
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
	
	// Bottom Indicator View
	@ViewBuilder
	func BottomIndicatorView() -> some View {
		/// Let's make this scrollview start and end in the centre, and also make it a snap carousel.
		GeometryReader {
			let size = $0.size
			
			ScrollView(.horizontal) {
				LazyHStack(spacing: 5) {
					ForEach(coordinator.items) { item in
						// Preview Image View
						if let image = item.previewImage {
							Image(uiImage: image)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 50, height: 50)
								.clipShape(.rect(cornerRadius: 10))
								.scaleEffect(0.97)
						}
					}
				}
				.padding(.vertical, 10)
				.scrollTargetLayout()
			}
			// 50 - Item Size Inside ScrollView
			.safeAreaPadding(.horizontal, (size.width - 50) / 2)
			.overlay {
				// Active Indicator Icon
				RoundedRectangle(cornerRadius: 10)
					.stroke(.primary, lineWidth: 2.0)
					.frame(width: 50, height: 50)
					.allowsHitTesting(false)
			}
			.scrollTargetBehavior(.viewAligned)
			/// Let's sync the bottom scrollview and the paging view so that any changes made at the bottom view are reflected in the paging view as well.
			.scrollPosition(id: .init(get: { return coordinator.detailIndicatorPosition }, set: { coordinator.detailIndicatorPosition = $0 }))
			.scrollIndicators(.hidden)
			.onChange(of: coordinator.detailIndicatorPosition) { oldValue, newValue in
				coordinator.didDetailIndicatorPageChanged()
			}
		}
		.frame(height: 70)
		.background {
			Rectangle()
				.fill(.ultraThinMaterial)
				.ignoresSafeArea()
		}
	}
}

#Preview {
	PhotosAppContentView()
}
