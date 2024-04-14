import Foundation
import SwiftUI

// This currently doesn't work anymore. When the offset reader is pushed too far outside the screen, it doesn't return the correct offset anymore
// To fix it:
// That’s because TabView removes the view when it's out of the screen. Check out this video where I implemented an offset method to read the entire scroll offset of the tabview.
// https://youtu.be/W-uSGXhuFHY

struct AnimatedPageIndicatorHomeView: View {
	var colors: [Color] = [.red, .blue, .pink, .purple]
	
	@State private var selectedColor: Color = .red
	@State private var offset: CGFloat = 0
	
	var body: some View {
		// TabView has problem in ignoring safe area top edge.
		// the fix is to use scroll view. using .init() creates an empty option set.
		ScrollView(.init()) {
			TabView(selection: $selectedColor) {
				ForEach(colors, id: \.self) { color in
					color
						.tag(color)
						.offsetX(color == selectedColor) { rect in
							let minX = rect.minX
							let pageOffset = minX - (getWidth() * CGFloat(getColorIndex(color)))
							self.offset = -pageOffset
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
	
	func getColorIndex(_ of: Color) -> Int {
		return colors.firstIndex(of: of) ?? 0
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
