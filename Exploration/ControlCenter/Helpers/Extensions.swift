import SwiftUI

extension View {
	// Reverse Mask Modifier
	@ViewBuilder
	func reverseMask<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
		self
			.mask {
				Rectangle()
					.overlay {
						content()
							.blendMode(.destinationOut)
					}
			}
	}
	
	// Custom Background Modifier
	@ViewBuilder
	func addRoundedBG() -> some View {
		self
			.background {
				RoundedRectangle(cornerRadius: 18, style: .continuous)
					.fill(.thinMaterial)
			}
	}
	
	// Hiding Content
	/// A simple modifier that allows us to hide other contents whenever any of the given configuration is expanded.
	@ViewBuilder
	func hideView(_ configs: [SliderConfig]) -> some View {
		let status = configs.contains(where: { $0.expand })
		self
			.opacity(status ? 0 : 1)
			.animation(.easeInOut(duration: 0.2), value: status)
	}
}
