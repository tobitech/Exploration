import Foundation

struct InviteCard: Identifiable, Hashable {
	var id: String = UUID().uuidString
	var image: String
}

extension InviteCard {
	static let cards: [InviteCard] = [
		.init(image: "Pic 1"),
		.init(image: "Pic 2"),
		.init(image: "Pic 3"),
		.init(image: "Pic 4")
	]
}
