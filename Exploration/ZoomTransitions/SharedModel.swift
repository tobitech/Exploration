import Foundation
import SwiftUI
import AVKit

@Observable
class SharedModel {
	var videos: [VideoModel] = videoFiles

	/// This helper method creates a thumbnail image from the video URL at 0 seconds.
	/// If you require a thumbnail at a different time, modify the zero value to another time value.
	func generateThumbnail(for video: Binding<VideoModel>, size: CGSize) async {
		do {
			let asset = AVURLAsset(url: video.wrappedValue.fileURL)
			let generator = AVAssetImageGenerator(asset: asset)
			generator.maximumSize = size
			generator.appliesPreferredTrackTransform = true
			
			let cgImage = try await generator.image(at: .zero).image
			guard let deviceColorBasedImage = cgImage.copy(
				colorSpace: CGColorSpaceCreateDeviceRGB()
			) else {
				return
			}
			let thumbnail = UIImage(cgImage: deviceColorBasedImage)
			await MainActor.run {
				video.wrappedValue.thumbnail = thumbnail
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
