import Foundation
import SwiftUI

struct AnimatedPageIndicatorHomeView: View {
	var colors: [Color] = [.red, .blue, .pink, .purple]
	
	@State private var offset: CGFloat = 0
	
	var body: some View {
		// TabView has problem in ignoring safe area top edge.
		// the fix is to use scroll view. using .init() creates an empty option set.
		ScrollView(.init()) {
			TabView {
				ForEach(colors.indices, id: \.self) { index in
					if index == 1 {
						colors[index]
							.overlay(alignment: .leading) {
								GeometryReader { proxy -> Color in
									let minX = proxy.frame(in: .global).minX
									DispatchQueue.main.async {
										withAnimation(.default) {
											self.offset = -minX
										}
									}
									return Color.clear
								}
								.frame(width: 0, height: 0)
							}
					} else {
						colors[index]
					}
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.overlay(alignment: .bottom) {
				// Animated Indicators
				HStack(spacing: 15) {
					ForEach(colors.indices, id: \.self) { index in
						Capsule()
							.fill(.white)
							.frame(width: getIndex() == index ? 20 : 8, height: 8)
					}
				}
				// Smooth sliding effect.
				.overlay(alignment: .leading) {
					Capsule()
						.fill(.white)
						.frame(width: 20, height: 8)
						.offset(x: getOffset())
				}
				.padding(.bottom, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom)
				.padding(.bottom, 10)
			}
		}
		.ignoresSafeArea()
	}
	
	// Getting index
	func getIndex() -> Int {
		let index = Int(round(Double(offset / getWidth())))
		return index
	}
	
	// Getting Offset for Capsule Shape
	func getOffset() -> CGFloat {
		// Spacing - 15
		// Circle Width = 8
		// Total = 23
		let progress = offset / getWidth()
		return 23 * progress
	}
}

// Extending View to get width
extension View {
	func getWidth() -> CGFloat {
		return UIScreen.main.bounds.width
	}
}

#Preview {
	AnimatedPageIndicatorContentView()
}
