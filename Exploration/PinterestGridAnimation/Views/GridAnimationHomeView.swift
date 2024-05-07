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
		.opacity(coordinator.hideRootView ? 0 : 1)
		.scrollDisabled(coordinator.hideRootView)
		/// Disabling user interaction for the source view when the detail view is expanded, and vice versa
		.allowsHitTesting(!coordinator.hideRootView)
		.overlay {
			DetailView()
				.environment(coordinator)
			/// Disabling user interaction for the source view when the detail view is expanded, and vice versa
				.allowsHitTesting(coordinator.hideLayer)
		}
	}
	
	// Post Card View
	@ViewBuilder
	func PostCardView(_ post: PGridItem) -> some View {
		GeometryReader {
			let frame = $0.frame(in: .global)
			ImageView(post: post)
				.clipShape(.rect(cornerRadius: 10))
				.contentShape(.rect(cornerRadius: 10))
				.onTapGesture {
					coordinator.toggleView(show: true, frame: frame, post: post)
				}
		}
		/// You can change the height of the card view and the animation will still work perfectly.
		.frame(height: 180)
	}
}

#Preview {
	GridAnimationContentView()
}
