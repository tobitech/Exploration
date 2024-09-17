import SwiftUI
import AVKit

struct VideoDetailView: View {
	var video: VideoModel
	var animation: Namespace.ID
	@Environment(SharedModel.self) private var sharedModel
	// View Properties
	@State private var hidesThumbnail: Bool = false
	@State private var scrollID: UUID?
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			Color.black
			
			ScrollView(.vertical) {
				LazyVStack(spacing: 0) {
					ForEach(sharedModel.videos) { video in
						VideoPlayerView(video: video)
							.frame(width: size.width, height: size.height)
					}
				}
				.scrollTargetLayout()
			}
			.scrollPosition(id: $scrollID)
			.scrollTargetBehavior(.paging)
			.scrollIndicators(.hidden)
			.zIndex(hidesThumbnail ? 1 : 0)
			
			if let thumbnail = video.thumbnail, !hidesThumbnail {
				Image(uiImage: thumbnail)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipShape(.rect(cornerRadius: 15))
					.task {
						scrollID = video.id
						/// A 1.5-second delay is used to settle the transition animations, and once the transition is complete, the scrollview moves to the front of the ZStack, making the view scrollable.
						try? await Task.sleep(for: .seconds(0.15))
						hidesThumbnail = true
					}
			}
		}
		.ignoresSafeArea()
		/// The second step is to add the navigationTransition modifier to the detail view, and that's all. With these two modifiers, we can create a zoom transition effect.
		/// Now, let's use the thumbnail image we created earlier on the detail view, which makes the transition look more like a hero effect.
		.navigationTransition(.zoom(sourceID: hidesThumbnail ? scrollID ?? video.id : video.id, in: animation))
	}
}

struct VideoPlayerView: View {
	var video: VideoModel
	@State private var player: AVPlayer?
	var body: some View {
		ZoomVideoPlayer(player: $player)
			.onAppear{
				guard player == nil else { return }
				player = AVPlayer(url: video.fileURL)
			}
			.onDisappear {
				player?.pause()
			}
		/// With the help of this new scroll API, we can easily identify when the view is visible on the screen or not, and if not, we can pause the video.
			.onScrollVisibilityChange { isVisible in
				if isVisible {
					player?.play()
				} else {
					player?.pause()
				}
			}
			.onGeometryChange(for: Bool.self) { proxy in
				let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
				let height = proxy.size.height * 0.97
				return -minY > height || minY > height
			} action: { newValue in
				if newValue {
					player?.pause()
					player?.seek(to: .zero)
				}
			}

	}
}

#Preview {
	ZoomTransitionsContentView()
}
