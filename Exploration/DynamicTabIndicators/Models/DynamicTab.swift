import SwiftUI

struct DynamicTab: Identifiable, Hashable {
	var id = UUID()
	var title: String
	// Tab Animation Properties
	var width: CGFloat = 0
	var minX: CGFloat = 0
}

// Title is same as asset image.
var dynamicTabs: [DynamicTab] = [
	.init(title: "Pic 1"),
	.init(title: "Pic 2"),
	.init(title: "Pic 3"),
	.init(title: "Pic 4")
]
