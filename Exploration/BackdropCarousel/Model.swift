import Foundation

struct BImageModel: Identifiable {
	var id: String = UUID().uuidString
	var altText: String
	var image: String
}

extension BImageModel {
	static let images: [BImageModel] = [
		/// https://www.pexels.com/photo/green-palm-tree-near-white-and-black-dome-building-under-blue-sky-9002742/
		.init(altText: "Mo Eid", image: "Pic 16"),
		/// https://www.pexels.com/photo/a-gradient-wallpaper-7135121/
		.init(altText: "Codioful", image: "Pic 17"),
		/// https://www.pexels.com/photo/high-speed-photography-of-colorful-ink-diffusion-in-water-9669094/
		.init(altText: "Cottonbro", image: "Pic 18"),
		/// https://www.pexels.com/photo/multicolored-abstract-painting-2868948/
		.init(altText: "Anni", image: "Pic 19")
	]
}
