import Foundation

struct ImageModel: Identifiable {
	var id = UUID()
	var image: String
}

var images: [ImageModel] = (1...8)
	.compactMap { ImageModel(image: "Pic \($0)") }
