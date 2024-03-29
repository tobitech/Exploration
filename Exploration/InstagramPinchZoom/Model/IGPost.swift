import Foundation

struct IGPost: Identifiable {
	var id = UUID()
	var author: String
	var title: String
	var image: String
	var url: String
}

var igPosts: [IGPost] = [
	.init(author: "iJustine", title: "First look at the M3 MacBook Air 99", image: "Pic 1", url: "https://youtu.be/uhXbQViIcs"),
	.init(
		author:
			"iJustine", title:
			"Apple Vision Pro - Unboxing, Review and demos!", image: "Pic 2", url: "https://youtu.be/CaWt6-xe29k"),
	.init(author: "Joseba Garcia Moya", title: "Rabbit on Grass", image: "Pic 3", url: "https://www.pexels.com/photo/tabbit=on=ras5-19126536"),
	.init(
		author:
			"Toa Heftiba §inca",
		title:
			"Photograph of a Wall With Grafitti",
		image:
			"Pic 4",
		url:
			"https://www.pexels.com/photo/selective-photograph-of-a-wall-with-grafitti-1194420/"
	)
]
