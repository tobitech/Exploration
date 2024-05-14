import SwiftUI

extension View {
	/// This modifier will extract the item's position in the scrollview as well as the scrollview boundaries values, which we can then use to determine whether the item is visible or not.
	@ViewBuilder
	func didFrameChange(result: @escaping (CGRect, CGRect) -> Void) -> some View {
		self
			.overlay {
				GeometryReader {
					let frame = $0.frame(in: .scrollView(axis: .vertical))
					let bounds = $0.bounds(of: .scrollView(axis: .vertical)) ?? .zero
					
					Color.clear
						.preference(key: PhotosFrameKey.self, value: .init(frame: frame, bounds: bounds))
						.onPreferenceChange(PhotosFrameKey.self, perform: { value in
							result(value.frame, value.bounds)
						})
				}
			}
	}
}

struct ViewFrame: Equatable {
	var frame: CGRect = .zero
	var bounds: CGRect = .zero
}

struct PhotosFrameKey: PreferenceKey {
	static var defaultValue: ViewFrame = .init()
	
	static func reduce(value: inout ViewFrame, nextValue: () -> ViewFrame) {
		value = nextValue()
	}
}
