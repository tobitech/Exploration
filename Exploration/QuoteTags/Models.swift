import SwiftUI

struct QuoteTag: Identifiable, Hashable {
	var id = UUID()
	let name: String
}

var quotes: [QuoteTag] = [
	.init(name: "business"),
	.init(name: "change"),
	.init(name: "character"),
	.init(name: "competition"),
	.init(name: "conservative"),
	.init(name: "courage"),
	.init(name: "education"),
	.init(name: "faith"),
	.init(name: "family"),
	.init(name: "famous-quotes"),
	.init(name: "film"),
	.init(name: "freedom"),
	.init(name: "friendship"),
	.init(name: "future"),
	.init(name: "happiness"),
	.init(name: "history"),
	.init(name: "honor"),
	.init(name: "humour"),
	.init(name: "humorous"),
	.init(name: "leadership"),
	.init(name: "life"),
	.init(name: "literature"),
	.init(name: "love"),
	.init(name: "motivational"),
	.init(name: "nature"),
	.init(name: "inspirational")
]
