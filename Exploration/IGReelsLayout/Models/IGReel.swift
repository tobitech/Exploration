import SwiftUI

struct IGReel: Identifiable {
	var id = UUID()
	var videoID: String
	var authorName: String
	var isLiked: Bool = false
}

var reelsData: [IGReel] = [
	.init(videoID: "Reel 1", authorName: "Tima Miroshnichenko"),
	.init(videoID: "Reel 2", authorName: "Trippy Clicker"),
	.init(videoID: "Reel 3", authorName: "Tima Miroshnichenko"),
	.init(videoID: "Reel 4", authorName: "Ana Benet"),
	.init(videoID: "Reel 5", authorName: "Anna Medvedeva")
]
