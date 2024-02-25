import SwiftUI

struct AlertView<Content: View>: View {
	@Binding var config: AlertConfig
	// View Tag
	var tag: Int
	@ViewBuilder var content: () -> Content
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				if config.enableBackgroundBlur {
					Rectangle()
						.fill(.ultraThinMaterial)
				} else {
					Rectangle()
						.fill(.primary.opacity(0.25))
				}
			}
			.ignoresSafeArea()
			.contentShape(.rect)
			
			if config.transitionType == .slide {
				content()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.transition(.move(edge: config.slideEdge))
			} else {
				content()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
	}
}
