import SwiftUI

struct PGridItem: Identifiable {
	private(set) var id = UUID()
	var title: String
	var image: UIImage?
}

var sampleImages: [PGridItem] = [
	.init(title: "Abril Altamirano", image: UIImage(named: "Pic 1")),
	.init(title: "Gülsah Aydogan", image: UIImage(named:"Pic 2")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 3")),
	.init(title:"Maahid Photos", image: UIImage(named: "Pic 4")),
	.init(title: "Pelageia Zelenina", image: UIImage(named: "Pic 5")),
	.init(title: "Ofir Eliav", image: UIImage(named:"Pic 6")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 7")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 8")),
	.init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic 9")),
	.init(title: "Erik Mclean", image: UIImage(named: "Pic 10")),
	.init(title: "Fatma DELIASLAN", image: UIImage(named: "Pic 11"))
]
