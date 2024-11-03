import SwiftUI

struct FamilyRootView: View {
	@State private var showScanView = false
	@State private var dragOffset: CGFloat = 0
	
	var body: some View {
		ZStack {
			FamilyScanView()
			FamilyMainView(showScanView: $showScanView)
				.clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: showScanView ? 30 : 0, topTrailing: showScanView ? 30 : 0)))
				.ignoresSafeArea()
				.offset(y: calculatedOffset())
				.animation(.snappy, value: showScanView)
				.gesture(
					dragGesture
				)
		}
	}
	
	private var dragGesture: some Gesture {
		DragGesture()
			.onChanged { value in
				if showScanView && value.translation.height < 0 {
					dragOffset = value.translation.height
				}
			}
			.onEnded { value in
				if showScanView {
					let threshold = UIScreen.main.bounds.height * 0.35
					let velocity = value.predictedEndLocation.y - value.location.y
					
					withAnimation(.snappy) {
						if dragOffset < -threshold || velocity < -300 {
							showScanView = false
						}
						dragOffset = 0
					}
				}
			}
	}
	
	private func calculatedOffset() -> CGFloat {
		guard showScanView else { return 0 }
		return UIScreen.main.bounds.height * 0.7 + dragOffset
	}
}

#Preview {
	FamilyRootView()
}
