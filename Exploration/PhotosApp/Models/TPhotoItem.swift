import SwiftUI

struct TPhotoItem: Identifiable, Equatable {
	var id = UUID().uuidString
	var title: String
	var image: UIImage?
	var previewImage: UIImage?
	var appeared: Bool = false
}

var samplePhotoItems: [TPhotoItem] = [
	.init(title: "Fanny Hagan", image: UIImage(named: "Pic 1")),
	.init(title: "Han-Chieh Lee", image: UIImage(named: "Pic 2")),
	.init(title: "H$ E", image: UIImage(named: "Pic 3")),
	.init(title: "Abril Altamirano", image: UIImage(named: "Pic 4")),
	.init(title: "Gül$ah Aydogan", image: UIImage(named: "Pic 5")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 6")),
	.init(title: "Maahid Photos", image: UIImage(named: "Pic 7")),
	.init(title: "Pelageia Zelenina", image: UIImage(named: "Pic 8" )),
	.init(title: "Ofir Eliav", image: UIImage(named: "Pic 9")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 10")),
	.init(title: "Melike Melikesayar", image: UIImage(named: "Pic 11")),
	.init(title: "Sayar Melikesayar", image: UIImage(named: "Pic 12")),
	.init(title: "Melike Melikesayar", image: UIImage(named: "Pic 13")),
	.init(title: "Melike Melikesayar", image: UIImage(named: "Pic 14")),
	.init(title: "Melike Melikesayar", image: UIImage(named: "Pic 15")),
]
