import SwiftUI

struct FamilyRootView: View {
	@State private var showScanView = false
	@State private var dragOffset: CGFloat = 0
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			ZStack {
				FamilyScanView()
				FamilyMainView(showScanView: $showScanView)
					.clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: showScanView ? 30 : 0, topTrailing: showScanView ? 30 : 0)))
					.ignoresSafeArea()
					.offset(y: calculatedOffset())
					.animation(.snappy, value: showScanView)
					.gesture(
						DragGesture()
							.onChanged { value in
								guard showScanView else { return }
								let translation = min(value.translation.height, 0)
								dragOffset = translation
							}
							.onEnded { value in
								guard showScanView else { return }
								let translation = min(value.translation.height, 0)
								let velocity = value.velocity.height / 5
								withAnimation(.snappy) {
									if (translation + velocity) < -(size.height * 0.3) {
										showScanView = false
									}
									
									dragOffset = 0
								}
							}
					)
			}
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
