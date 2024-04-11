import SwiftUI

struct OffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

extension View {
	@ViewBuilder
	func offsetX(_ addObserver: Bool, completion: @escaping (CGRect) -> Void) -> some View {
		self
			.frame(maxWidth: .infinity)
			.overlay {
				// This is to prevent every card in the scroll view to observe the offset changes.
				if addObserver {
					GeometryReader {
						let rect = $0.frame(in: .global)
						Color.clear
							.preference(key: OffsetKey.self, value: rect)
							.onPreferenceChange(OffsetKey.self, perform: completion)
					}
				}
			}
	}
}
