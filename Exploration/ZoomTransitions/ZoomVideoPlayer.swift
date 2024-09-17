import SwiftUI
import AVKit

struct ZoomVideoPlayer: UIViewControllerRepresentable {
	@Binding var player: AVPlayer?
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
		controller.videoGravity = .resizeAspectFill
		controller.showsPlaybackControls = false
		return controller
	}
	
	func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
		uiViewController.player = player
	}
}
