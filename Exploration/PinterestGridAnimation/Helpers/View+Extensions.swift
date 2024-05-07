import SwiftUI

extension View {
	var safeArea: UIEdgeInsets {
		if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
			return safeArea
		}
		
		return .zero
	}
	
	@ViewBuilder
	func offsetY(result: @escaping (CGFloat) -> Void) -> some View {
		self
			.overlay {
				GeometryReader {
					let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
					Color.clear
						.preference(key: PGridOffsetKey.self, value: minY)
						.onPreferenceChange(PGridOffsetKey.self, perform: { value in
							result(value)
						})
				}
			}
	}
}

// Preference Keys
struct PGridOffsetKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
