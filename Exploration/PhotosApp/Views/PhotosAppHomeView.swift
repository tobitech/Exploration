import SwiftUI

struct PhotosAppHomeView: View {
	@Environment(PhotoUICoordinator.self) private var coordinator
	
	var body: some View {
		ScrollView(.vertical) {
			LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3, content: {
				ForEach(coordinator.items) { item in
					GridImageView(item)
						.onTapGesture {
							coordinator.selectedItem = item
						}
				}
			})
			.padding(.vertical, 15)
		}
		.navigationTitle("Recents")
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
