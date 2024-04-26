import SwiftUI

struct MaterialCarouselHomeView: View {
	
	// View Properties
	@State private var cards: [MaterialCarouselCard] = [
		.init(image: "Pic 1"),
		.init(image: "Pic 2"),
		.init(image: "Pic 3"),
		.init(image: "Pic 4"),
		.init(image: "Pic 5"),
		.init(image: "Pic 6"),
		.init(image: "Pic 7"),
		.init(image: "Pic 8"),
	]
	
	var body: some View {
		VStack {
			GeometryReader {
				let size = $0.size
				
				ScrollView(.horizontal) {
					HStack(spacing: 10) {
						ForEach(cards) { card in
							CardView(card)
						}
					}
					/// AS YOU CAN SEE, WE NEED TO ADD MORE PADDING TO SCROLLVIEW IN ORDER TO HAVE THE CAROUSEL END AT THE LAST CARD SINCE WE NEED IT TO. BUT FIGURING OUT THE EXTRA PADDING IS ACTUALLY FAIRLY EASY. JUST USE THE SCREEN SIZE AND SUBTRACT THE CARD WIDTH EROM IT TO GET THE EXACT AMOUNT WE NEED
					.padding(.trailing, size.width - 180)
					.scrollTargetLayout()
				}
				.scrollTargetBehavior(.viewAligned)
				.scrollIndicators(.hidden)
				.clipShape(.rect(cornerRadius: 25))
			}
			.padding(.horizontal, 15)
			.padding(.top, 30)
			.frame(height: 210)
			
			Spacer(minLength: 0)
		}
	}
	
	/// Only the size of the view inside the container has changed, and since the width of each container is the same as 180, we must relocate all the views precisely to match the resizing.
	/// Think about the following illustration:Since the first view did not change in size at all, there is no offset that needs to be adjusted for the second view.
	/// Now that the second view has been shrunk by 100 points, the third view must be advanced by 100 points to match the second view's size change. Because of this, I added a variable named previousOffset to the "Card Model" to keep track of the previous view offset to match the current view position.
	/// All of the views inside the scrollview will follow this same pattern.
	
	// Card View
	@ViewBuilder
	func CardView(_ card: MaterialCarouselCard) -> some View {
		/// In order to reduce the size of the card, I'm going to turn each card into a progress value that ranges from 0 to 130 and is based on the MinX Value.
		/// Later, I'm using this progress value to reduce the card width since the first card will have a zero min value, thus the first card will be at its full width, and the subsequent cards widths will alter, thus their minX values varying.
		/// You can now see that the card width has decreased for the succeeding cards but that it is increasing as we scroll. Simply alter the logic so that when minX is less than O, the progress will be too positive rather than negative. Doing this will resolve the issue.
		GeometryReader { proxy in
			let size = proxy.size
			let minX = proxy.frame(in: .scrollView).minX
			// 190: 180 - (Card Width); 10 - (spacing)
			let reducingWidth = (minX / 190) * 130
			/// You can update the width of the proceeding cards as per your needs. i.e. the 130
			let cappedWidth = min(reducingWidth, 130)
			
			let frameWidth = size.width - (minX > 0 ? cappedWidth : -cappedWidth)
			
			Image(card.image)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: size.width, height: size.height)
				/// Using just frameWidth here throws a runtime warning: "Invalid frame dimension (negative or non-finite)
			/// that's why we're doing the ternary operation.
				.frame(width: frameWidth < 0 ? 0 : frameWidth)
				.clipShape(.rect(cornerRadius: 25))
			/// As you can see, the size problem is resolved, but we do have a new one: there is a gap that is creating while we scroll. This is happening because since we reduced the card width, it's moving forward, so moving it in the opposite direction will solve this problem.
				.offset(x: minX > 0 ? 0 : -cappedWidth)
				.offset(x: -card.previousOffset)
		}
		.frame(width: 180, height: 200)
		.offsetX { offset in
			let reducingWidth = (offset / 190) * 130
			let index = cards.indexOf(card)
			if cards.indices.contains(index + 1) {
				cards[index + 1].previousOffset = (offset < 0 ? 0 : reducingWidth)
			}
		}
	}
}

#Preview {
	MaterialCarouselContentView()
}
