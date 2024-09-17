import Foundation
import UIKit

struct VideoModel: Identifiable, Hashable {
	var id = UUID()
	var fileURL: URL
	var thumbnail: UIImage?
}

let videoFiles = [
	URL(filePath: Bundle.main.path(forResource: "Reel 1", ofType: "mp4") ?? ""),
	URL(filePath: Bundle.main.path(forResource: "Reel 2", ofType: "mp4") ?? ""),
	URL(filePath: Bundle.main.path(forResource: "Reel 3", ofType: "mp4") ?? ""),
	URL(filePath: Bundle.main.path(forResource: "Reel 4", ofType: "mp4") ?? ""),
	URL(filePath: Bundle.main.path(forResource: "Reel 5", ofType: "mp4") ?? ""),
].compactMap { VideoModel(fileURL: $0) }
