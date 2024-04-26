import SwiftUI

/// To read the offset in order to find how much the view has been reduced
/// the same as we did it inside the Geometry Reader to find the capped width),
struct CarouselOffsetKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

extension View {
	@ViewBuilder
	func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
		self
			.overlay {
				GeometryReader {
					let minX = $0.frame(in: .scrollView).minX
					Color.clear
						.preference(key: CarouselOffsetKey.self, value: minX)
						.onPreferenceChange(CarouselOffsetKey.self, perform: completion)
				}
			}
	}
}

// Card Array Extension
extension [MaterialCarouselCard] {
	func indexOf(_ card: MaterialCarouselCard) -> Int {
		return self.firstIndex(of: card) ?? 0
	}
}
