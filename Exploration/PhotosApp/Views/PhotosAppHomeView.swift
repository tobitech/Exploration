import SwiftUI

struct PhotosAppHomeView: View {
	@Environment(PhotoUICoordinator.self) private var coordinator
	
	var body: some View {
		@Bindable var bindableCoordinator = coordinator
		/// For some reason, SwiftUl's new scrollPosition modifier causes Scrollview to stutter when LazyGrid is used, therefore I use ScrollViewReader as an alternative.
		ScrollViewReader { reader in
			ScrollView(.vertical) {
				LazyVStack(alignment: .leading, spacing: 0) {
					Text("Recents")
						.font(.largeTitle.bold())
						.padding(.top, 20)
						.padding(.horizontal, 15)
					
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3, content: {
						ForEach($bindableCoordinator.items) { $item in
							GridImageView(item)
								.id(item.id)
								.didFrameChange(result: { frame, bounds in
									/// Since the grid is lazy, when the item is disposed of, changing the value to false, and when maxY is less than 0 indicates that the item is scrolled away in an upward direction, and when minY is more than scrollview Height indicates that the item is scrolled away in a downward direction.
									let minY = frame.minY
									let maxY = frame.maxY
									let height = bounds.height
									
									if maxY < 0 || minY > height {
										item.appeared = false
									} else {
										item.appeared = true
									}
								})
								.onDisappear {
									item.appeared = false
								}
								.onTapGesture {
									coordinator.selectedItem = item
								}
						}
					})
					.padding(.vertical, 15)
				}
			}
			/// I don't want to scroll when the item is still visible on the screen. Instead, I want to scroll when the item is invisible or moves away from the screen. We can utilize new geometry proxies to detect items that are visible or off-screen.
			/// To store this, I added the "appeared" property to my item model.
			.onChange(of: coordinator.selectedItem) { oldValue, newValue in
				if let item = coordinator.items.first(where: { $0.id == newValue?.id }), !item.appeared {
					// Scroll to this item, as this is not visible on the screen.
					reader.scrollTo(item.id, anchor: .bottom)
				}
			}
		}
		.toolbar(.hidden, for: .navigationBar)
		// .navigationTitle("Recents")
	}
	
	// Image View for Grid
	@ViewBuilder
	func GridImageView(_ item: TPhotoItem) -> some View {
		GeometryReader {
			let size = $0.size
			
			Rectangle()
				.fill(.clear)
				.anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
					return [item.id + "SOURCE": anchor]
				})
			
			if let previewImage = item.previewImage {
				Image(uiImage: previewImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipped()
					.opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
			}
		}
		.frame(height: 130)
		.contentShape(.rect)
	}
}

#Preview {
	PhotosAppContentView()
}
