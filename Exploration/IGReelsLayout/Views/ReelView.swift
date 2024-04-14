import AVFoundation
import SwiftUI

// Reel View
struct ReelView: View {
	@Binding var reel: IGReel
	@Binding var likedCounter: [Like]
	var size: CGSize
	var safeArea: EdgeInsets
	
	// View Properties
	@State private var player: AVPlayer?
	@State private var looper: AVPlayerLooper?
	
	var body: some View {
		GeometryReader {
			let rect = $0.frame(in: .scrollView(axis: .vertical))
			
			// Custom Video Player View
			CustomVideoPlayer(player: $player)
			// Offset Updates
				.preference(key: OffsetKey.self, value: rect)
				.onPreferenceChange(OffsetKey.self, perform: { value in
					playPause(value)
				})
				.overlay(alignment: .bottom) {
					ReelDetailsView()
				}
			// Double Tap Like Animation
				.onTapGesture(count: 2, perform: { position in
					let id = UUID()
					likedCounter.append(.init(id: id, tappedRect: position, isAnimated: false))
					// Animating Like
					withAnimation(.snappy(duration: 1.2), completionCriteria: .logicallyComplete) {
						if let index = likedCounter.firstIndex(where: { $0.id == id }) {
							likedCounter[index].isAnimated = true
						}
					} completion: {
						// Remove Like once it's finished
						likedCounter.removeAll(where: { $0.id == id })
					}
					
					// Liking the Reel
					reel.isLiked = true // even when it is tapped n time, it will only be set to true once.
				})
			// Creating Player
				.onAppear {
					guard player == nil else { return }
					guard let bundleId = Bundle.main.path(forResource: reel.videoID, ofType: "mp4") else { return }
					let videoURL = URL(filePath: bundleId)
					
					let playerItem = AVPlayerItem(url: videoURL)
					let queue = AVQueuePlayer(playerItem: playerItem)
					looper = AVPlayerLooper(player: queue, templateItem: playerItem)
					player = queue
				}
			// Clearing Player
				.onDisappear {
					player = nil
				}
		}
	}
	
	// Play/Pause Action
	func playPause(_ rect: CGRect) {
		/// So when the reel offset ranges from -half the height to half the height, the the reel will be played. Otherwise, the reel will get paused. This way we can play and pause only the reel that is on display.
		if -rect.minY < (rect.height * 0.5) && rect.minY < (rect.height * 0.5) {
			player?.play()
		} else {
			player?.pause()
		}
		
		if rect.minY >= size.height || -rect.minY >= size.height {
			player?.seek(to: .zero)
		}
	}
	
	// Reels Details & Controls
	@ViewBuilder
	func ReelDetailsView() -> some View {
		HStack(alignment: .bottom, spacing: 10) {
			VStack(alignment: .leading, spacing: 8) {
				HStack(spacing: 10) {
					Image(systemName: "person.circle.fill")
						.font(.largeTitle)
					Text(reel.authorName)
						.font(.callout)
						.lineLimit(1)
				}
				.foregroundStyle(.white)
				
				Text("Lorem Ipsum is simply dummy text of the printing and typesetting")
					.font(.caption)
					.foregroundStyle(.secondary)
					.lineLimit(2)
					.clipped()
			}
			
			Spacer(minLength: 0)
			
			// Controls View
			VStack(spacing: 35) {
				Button("", systemImage: reel.isLiked ? "suit.heart.fill" : "suit.heart") {
					reel.isLiked.toggle()
				}
				.symbolEffect(.bounce, value: reel.isLiked)
				.foregroundStyle(reel.isLiked ? .red : .white)
				
				Button("", systemImage: "message") {}
				Button("", systemImage: "paperplane") {}
				Button("", systemImage: "ellipsis") {}
			}
			.font(.title2)
			.foregroundStyle(.white)
		}
		.padding(.leading, 15)
		.padding(.trailing, 10)
		.padding(.bottom, safeArea.bottom + 15)
	}
}

#Preview {
	ReelsLayoutContentView()
}
