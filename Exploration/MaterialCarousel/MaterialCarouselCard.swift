import SwiftUI

// Card Model
struct MaterialCarouselCard: Identifiable, Hashable, Equatable {
	var id = UUID()
	var image: String
	var previousOffset: CGFloat = 0
}
