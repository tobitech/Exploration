import SwiftUI

struct ParticleEmitterHomeView: View {
	// View Properties
	@State private var isLiked: [Bool] = [false, false, false]
	
	var body: some View {
		VStack {
			HStack(spacing: 20) {
				CustomButton(
					systemImage: "suit.heart.fill",
					status: isLiked[0],
					activeTint: .pink,
					inActiveTint: .gray) {
						isLiked[0].toggle()
					}
				
				CustomButton(
					systemImage: "star.fill",
					status: isLiked[1],
					activeTint: .yellow,
					inActiveTint: .gray) {
						isLiked[1].toggle()
					}
				
				CustomButton(
					systemImage: "square.and.arrow.up.fill",
					status: isLiked[2],
					activeTint: .blue,
					inActiveTint: .gray) {
						isLiked[2].toggle()
					}
			}
		}
	}
	
	// Custom Button View
	@ViewBuilder
	func CustomButton(
		systemImage: String,
		status: Bool,
		activeTint: Color,
		inActiveTint: Color,
		onTap: @escaping () -> Void
	) -> some View {
		Button(action: onTap) {
			Image(systemName: systemImage)
				.font(.title2)
				.particleEffect(
					systemImage: systemImage,
					font: .title2,
					status: status,
					activeTint: activeTint,
					inActiveTint: inActiveTint
				)
				.foregroundStyle(status ? activeTint : inActiveTint)
				.padding(.horizontal, 18)
				.padding(.vertical, 8)
				.background {
					Capsule()
						.fill(status ? activeTint.opacity(0.25) : Color(uiColor: .darkGray))
				}
		}
	}
}

#Preview {
	ParticleEmitterContentView()
}
