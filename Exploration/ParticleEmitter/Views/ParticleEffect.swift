import SwiftUI

// Custom View Modifier
extension View {
	@ViewBuilder
	func particleEffect(
		systemImage: String,
		font: Font,
		status: Bool,
		activeTint: Color,
		inActiveTint: Color
	) -> some View {
		self
			.modifier(
				ParticleModifier(
					systemImage: systemImage,
					font: font, status: status,
					activeTint: activeTint, 
					inActiveTint: inActiveTint
				)
			)
	}
}

fileprivate struct ParticleModifier: ViewModifier {
	var systemImage: String
	var font: Font
	var status: Bool
	var activeTint: Color
	var inActiveTint: Color
	
	// View Properties
	@State private var particles: [Particle] = []
	
	func body(content: Content) -> some View {
		content
			.overlay(alignment: .top) {
				ZStack {
					ForEach(particles) { particle in
						Image(systemName: systemImage)
							.foregroundStyle(status ? activeTint : inActiveTint)
							.scaleEffect(particle.scale)
							.offset(x: particle.randomX, y: particle.randomY)
							.opacity(particle.opacity)
							// Only visible when status is true.
							.opacity(status ? 1 : 0)
							// Making base visibility with zero animation
							.animation(.none, value: status)
					}
				}
				.onAppear {
					// Adding base Particles For Animation
					if particles.isEmpty {
						// Change the size of the array (15) according to your needs.
						for _ in 1...15 {
							let particle = Particle()
							particles.append(particle)
						}
					}
				}
				.onChange(of: status) { _, newValue in
					if !newValue {
						// Reset Animation
						for index in particles.indices {
							particles[index].reset()
						}
					} else {
						// Activating Particles
						for index in particles.indices {
							// Random X and Y Calculations Based on Index.
							/// Instead of using random values for animation, we're going to use particle index to generate the random values. thus, when the progress goes above 0.5, all the particles will be placed on the right and everything else will be placed on the left, thus creating a V-shaped position. Then we can further add random values for a nicer positioned animation.
							
							let total: CGFloat = CGFloat(particles.count)
							let progress: CGFloat = CGFloat(index) / total
							
							let maxX: CGFloat = (progress > 0.5) ? 100 : -100
							let maxY: CGFloat = 60
							
							let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
							let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
							// Min scale is 0.35, Max scale is 1
							let randomScale: CGFloat = .random(in: 0.35...1)
							
							withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
								// Extra random values for spreading particles across the view.
								let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
								let extraRandomY: CGFloat = .random(in: 0...30)
								
								particles[index].randomX = randomX + extraRandomX
								particles[index].randomY = -randomY + extraRandomY
							}
							
							// Scaling with ease animation
							withAnimation(.easeIn(duration: 0.3)) {
								particles[index].scale = randomScale
							}
							
							// Removing particles based on index
							withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + (Double(index) * 0.005))) {
								particles[index].scale = 0.001
							}
						}
					}
				}
			}
	}
}

#Preview {
	ParticleEmitterContentView()
}
