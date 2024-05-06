import SwiftUI

struct GridAnimationHomeView: View {
	// UI Properties
	var coordinator: UICoordinator = .init()
	
	@State private var posts: [PGridItem] = sampleImages
	
	var body: some View {
		ScrollView(.vertical) {
			LazyVStack(alignment: .leading, spacing: 10) {
				Text("Welcome Back!")
					.font(.largeTitle.bold())
					.padding(.vertical, 10)
				
				// Grid Image View
				LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
					ForEach(posts) { post in
						PostCardView(post)
					}
				}
			}
			.padding(15)
			.background(ScrollViewExtractor(result: {
				coordinator.scrollView = $0
			}))
		}
	}
	
	// Post Card View
	@ViewBuilder
	func PostCardView(_ post: PGridItem) -> some View {
		GeometryReader {
			let frame = $0.frame(in: .global)
			if let image = post.image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: frame.width, height: frame.height, alignment: .center)
					.clipShape(.rect(cornerRadius: 10))
					.contentShape(.rect(cornerRadius: 10))
					.onTapGesture {
						// Store View's rect
						coordinator.rect = frame
						// Generating ScrollView's visible area Snapshot.
						
					}
			}
		}
		.frame(height: 180)
	}
}

#Preview {
	GridAnimationContentView()
}
