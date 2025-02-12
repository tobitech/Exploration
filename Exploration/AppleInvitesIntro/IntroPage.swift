import SwiftUI

struct IntroPage: View {
	// View Properties
	@State private var activeCard: InviteCard? = InviteCard.cards.first
	var body: some View {
		ZStack {
			// Ambient background View
			AmbientBackground()
			
			VStack(spacing: 40) {
				ScrollView(.horizontal) {
					HStack(spacing: 10) {
						ForEach(InviteCard.cards) { card in
							CarouselCardView(card)
						}
					}
				}
				.scrollIndicators(.hidden)
				.containerRelativeFrame(.vertical) { value, _ in
					value * 0.45
				}
			}
			.safeAreaPadding(15)
		}
	}
	
	@ViewBuilder
	private func AmbientBackground() -> some View {
		GeometryReader {
			let size = $0.size
			ZStack {
				ForEach(InviteCard.cards) { card in
					// You can use downsized image for this, but this video we will use the actual image.
					Image(card.image)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.ignoresSafeArea()
						.frame(width: size.width, height: size.height)
						// Only show active card image
						.opacity(activeCard?.id == card.id ? 1 : 0)
				}
				
				Rectangle()
					.fill(.black.opacity(0.45))
					.ignoresSafeArea()
			}
			.compositingGroup()
			.blur(radius: 90, opaque: true)
			.ignoresSafeArea()
		}
	}
	
	// Carousel Card View
	@ViewBuilder
	private func CarouselCardView(_ card: InviteCard) -> some View {
		GeometryReader {
			let size = $0.size
			Image(card.image)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: size.width, height: size.height)
				.clipShape(.rect(cornerRadius: 20))
				.shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
		}
		.frame(width: 220)
		.scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
			content
				.offset(y: phase == .identity ? -10 : 0)
				.rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
		}
	}
}

#Preview {
	IntroPageContentView()
}
