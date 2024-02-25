import SwiftUI

struct AlertView<Content: View>: View {
	@Binding var config: AlertConfig
	// View Tag
	var tag: Int
	@ViewBuilder var content: () -> Content
	
	// View Properties
	@State var showView: Bool = false
	
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
			.onTapGesture {
				if !config.disableOutsideTap {
					config.dismiss()
				}
			}
			.opacity(showView ? 1 : 0)
			
			if showView && config.transitionType == .slide {
				content()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.transition(.move(edge: config.slideEdge))
			} else {
				content()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.opacity(showView ? 1 : 0)
			}
		}
		.onAppear {
			config.showView = true
		}
		.onChange(of: config.showView) { oldValue, newValue in
			withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
				showView = newValue
			}
		}
	}
}
