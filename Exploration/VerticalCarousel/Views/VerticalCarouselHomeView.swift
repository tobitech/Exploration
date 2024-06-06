import SwiftUI

struct VerticalCarouselHomeView: View {
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			ScrollView(.vertical) {
				LazyVStack(spacing: 0) {
					ForEach(vSampleCards) { card in
						CardView(card)
							.frame(width: 220, height: 150)
						/// Now, let's change this carousel into a circular one using the visualEffect API.
							.visualEffect { content, geometryProxy in
								content
								/// As you can see, when we use the rotation modifier, the view simply spins at the same spot. However, if we apply an offset before applying the rotation modifier, the view will rotate in a circular form with the circle radius equal to the moved offset value. By using this concept, we can convert the vertical carousel into a circular one.
									.offset(x: -150)
									.rotationEffect(
										.init(degrees: cardRotation(geometryProxy)),
										anchor: .trailing
									)
								/// You may have noticed that the result isn't circular. This is because, when all the views are in one position, applying a rotation modifier will give us a circular pattern view. Nevertheless, we can use the same visual Effect API to ensure that every card remains at the top of the scrollview.
								/// I simply want some room on the leading side, so I'm moving the card slightly to the trailing side with the x offset value.
								/// To change the direction to the other side: change content x offset above to positive value,  change x offset to negative value, angleForEachCard to positive value, change frame alignment to leading, rotationEffect anchor to leading,
									.offset(x: 100, y: -geometryProxy.frame(in: .scrollView(axis: .vertical)).minY)
							}
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
				}
				.scrollTargetLayout()
			}
			/// As you can see, the scrollview has been turned into a snap carousel. 
			/// Let us now make this carousel start and end at the center point.
			/// 75 is half the value of our card view, thus the snap point will be at the middle rather than the top.
			.safeAreaPadding(.vertical, (size.height * 0.5) - 75)
			.scrollIndicators(.hidden)
			.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
			.background {
				Circle()
					.fill(.ultraThinMaterial)
					.frame(width: size.height, height: size.height)
					.offset(x: size.height / 2)
			}
			// .overlay {
				/// Let's put a divider in the middle of the screen to see if the card snaps at the center point.
//				Divider()
//					.background(.black)
//			}
			
			VStack(alignment: .leading, spacing: 12) {
				Button { } label: {
					Image(systemName: "arrow.left")
						.font(.title3.bold())
				}
				.buttonStyle(.plain)
				
				Text("Total")
					.font(.title3.bold())
					.padding(.top, 10)
				
				Text("$998.80")
					.font(.largeTitle)
				
				Text("Choose a card")
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
			.padding(15)
		}
		.toolbar(.hidden, for: .navigationBar)
	}
	
	// Card View
	@ViewBuilder
	func CardView(_ card: VCarouselCard) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25.0)
				.fill(card.color.gradient)
			// Card Details
			VStack(alignment: .leading, spacing: 10) {
				Image(.visa)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 40)
					.foregroundStyle(.white)
				
				Spacer(minLength: 0)
				
				HStack(spacing: 0) {
					ForEach(0..<3, id: \.self) { _ in
						Text("****")
						Spacer(minLength: 0)
					}
					
					Text(card.number)
						.offset(y: -2)
				}
				.font(.callout)
				.fontWeight(.semibold)
				.foregroundStyle(.white)
				.padding(.bottom, 10)
				
				HStack {
					Text(card.name)
					Spacer(minLength: 0)
					Text(card.date)
				}
				.font(.caption.bold())
				.foregroundStyle(.white)
			}
			.padding(25)
		}
	}
	
	// Card Rotation
	func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
		let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
		let height = proxy.size.height
		
		let progress = minY / height
		/// You can specify any angle value you desire, but l'm going with 50 degrees for each card to be turned when it isn't in the center.
		let angleForEachCard: CGFloat = -50
		/// This will snap the progress range from -1 to +1.
		/// Only one card is visible above and below the active card view since we snapped the progress range from -1 to +1. Changing the range will alter the number of visible cards above and below.
		let cappedProgress = progress < 0 ? min(max(progress, -3), 0) : max(min(progress, 3), 0)
		
		return cappedProgress * angleForEachCard
	}
}

#Preview {
	VerticalCarouselContentView()
}
