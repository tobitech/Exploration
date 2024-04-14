import AVKit
import SwiftUI

struct CustomVideoPlayer: UIViewControllerRepresentable {
	@Binding var player: AVPlayer?
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
		controller.videoGravity = .resizeAspectFill
		controller.showsPlaybackControls = false
		
		return controller
	}
	
	func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
		// Updating Player
		uiViewController.player = player
	}
}
