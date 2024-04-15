import SwiftUI

// Comments
/// Step 1:
//Create a weak variable called defaultDelegate: UIScrollViewDelegate? inside the coordinator class.
//Step 2:
//Add this Line before adding delegate to the scrollView,
//context.coordinator.defaultDelegate = scrollView.delegate
//Step 3:
//Now you can call the default SwiftUI scroll delegates with this defaultDelegate variable such as,
//func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//		defaultDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//}

struct LoopingScrollViewHomeView: View {
	// Sample Items
	@State private var items: [Item] = [.red, .blue, .green, .yellow, .black].compactMap { .init(color: $0) }
	
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				GeometryReader {
					let size = $0.size
					LoopingScrollView(width: size.width, spacing: 0, items: items) { item in
						RoundedRectangle(cornerRadius: 15)
							.fill(item.color.gradient)
							.padding(.horizontal, 15)
					}
					/// This new iOS 17 modifier allows us to add padding to the scroll content without affecting its actual bounds.
					// .contentMargins(.horizontal, 15, for: .scrollContent)
					/// NOTE: ViewAligned behavior will not work because we override the default Swiftul scroll delegate with our custom delegate. You can still call the default one by storing the delegate as the weak variable in the coordinator before setting the custom coordinator, and you can use the default methods.
					// .scrollTargetBehavior(.viewAligned)
					.scrollTargetBehavior(.paging)
				}
				.frame(height: 220)
			}
			.padding(.vertical, 15)
		}
		.scrollIndicators(.hidden)
	}
}

#Preview {
	LoopingScrollViewContentView()
}
