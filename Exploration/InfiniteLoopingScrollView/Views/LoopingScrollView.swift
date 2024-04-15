import SwiftUI

// Custom View
struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
	// Customisation Properties
	var width: CGFloat
	var spacing: CGFloat = 0
	
	var items: Item
	@ViewBuilder var content: (Item.Element) -> Content
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			// safety check
			let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
			
			ScrollView(.horizontal) {
				LazyHStack(spacing: spacing) {
					ForEach(items) { item in
						content(item)
							.frame(width: width)
					}
					
					ForEach(0..<repeatingCount, id: \.self) { index in
						let item = Array(items)[index % items.count]
						content(item)
							.frame(width: width)
					}
				}
				.background {
					ScrollViewHelper(
						width: width,
						spacing: spacing,
						itemsCount: items.count,
						repeatingCount: repeatingCount
					)
				}
			}
		}
	}
}

fileprivate struct ScrollViewHelper: UIViewRepresentable {
	var width: CGFloat
	var spacing: CGFloat
	var itemsCount: Int
	var repeatingCount: Int
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(
			width: width,
			spacing: spacing,
			itemsCount: itemsCount,
			repeatingCount: repeatingCount
		)
	}
	
	func makeUIView(context: Context) -> UIView {
		return UIView()
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
			if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
				scrollView.delegate = context.coordinator
				context.coordinator.isAdded = true
			}
		}
		
		context.coordinator.width = width
		context.coordinator.spacing = spacing
		context.coordinator.itemsCount = itemsCount
		context.coordinator.repeatingCount = repeatingCount
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var width: CGFloat
		var spacing: CGFloat
		var itemsCount: Int
		var repeatingCount: Int
		
		init(
			width: CGFloat,
			spacing: CGFloat,
			itemsCount: Int,
			repeatingCount: Int
		) {
			self.width = width
			self.spacing = spacing
			self.itemsCount = itemsCount
			self.repeatingCount = repeatingCount
		}
		
		// Tell us whether the delegate is added or not.
		var isAdded: Bool = false
		
		/// When the repeated first initial item scrolls to the start point, we can adjust the scroll position to the actual start, which will make it loop from one side, giving the impression that it is looping the elements while we scroll. On the other hand, we can scroll the position to the last when the actual start moves away from the start point, this will give the loop effect on the other side, making it completely looped on both sides. To determine how many items should be repeated, divide the actual scrollview size by the given item size.
		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			guard itemsCount > 0 else { return }
			
			let minX = scrollView.contentOffset.x
			// as you can see from the print statement, the offset starts at -15 because of the content margin we've applied to the scrollview.
			// print(minX)
			let mainContentSize = CGFloat(itemsCount) * width
			let spacingSize = CGFloat(itemsCount) * spacing
			// print(mainContentSize + spacingSize)
			if minX > (mainContentSize + spacingSize) {
				scrollView.contentOffset.x -= (mainContentSize + spacingSize)
			}
			
			if minX < 0 {
				scrollView.contentOffset.x += (mainContentSize + spacingSize)
			}
		}
	}
}

#Preview {
	LoopingScrollViewContentView()
}
