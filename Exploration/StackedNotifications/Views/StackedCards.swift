import SwiftUI

struct StackedCards<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
	
	var items: Data
	/// "StackedDisplayCount" represents the number of extra cards that will be displayed following the active card view.
	var stackedDisplayCount: Int = 2
	/// The number of extra cards needed to get the opacity effect after the main card will be determined by this property.
	var opacityDisplayCount: Int = 2
	var spacing: CGFloat = 5
	var itemHeight: CGFloat
	@ViewBuilder var content: (Data.Element) -> Content
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let topPadding: CGFloat = size.height - itemHeight
			
			ScrollView(.vertical) {
				VStack(spacing: spacing) {
					ForEach(items) { item in
						content(item)
							.frame(height: itemHeight)
						/// Now, let's use the new VisualEffect API to make the scrollview appear stacked.
							.visualEffect { content, geometryProxy in
								content
									.opacity(opacity(geometryProxy))
									.scaleEffect(scale(geometryProxy), anchor: .bottom)
									.offset(y: offset(geometryProxy))
							}
							.zIndex(zIndex(item))
					}
				}
				.scrollTargetLayout()
				.overlay(alignment: .top) {
					HeaderView(topPadding)
				}
			}
			.scrollIndicators(.hidden)
			.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
			/// The reason for using safeAreaPadding instead of standard padding is that it adds padding directly to the scrollContent rather than the scrollview, allowing us to scroll the stack and move it all the way to the top as it scrolls.
			.safeAreaPadding(.top, topPadding)
		}
	}
	
	// Header View
	@ViewBuilder
	func HeaderView(_ topPadding: CGFloat) -> some View {
		VStack(spacing: 0) {
			Text(Date.now.formatted(date: .complete, time: .omitted))
				.font(.title3.bold())
			Text("9:41")
				.font(.system(size: 100, weight: .bold, design: .rounded))
				.padding(.top, -15)
		}
		.foregroundStyle(.white)
		.visualEffect { content, geometryProxy in
			content
				.offset(y: headerOffset(geometryProxy, topPadding))
		}
	}
	
	// HeaderOffset
	/// This will keep the header view at the top until the scrollview is not close to it. When the scrollview reaches the header view, the header view will scroll along with it.
	func headerOffset(_ proxy: GeometryProxy, _ topPadding: CGFloat) -> CGFloat {
		let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
		let viewSize = proxy.size.height - itemHeight
		return -minY > (topPadding - viewSize) ? -viewSize : -minY - topPadding
	}
	
	// ZIndex to reverse the stack.
	/// Now that the cards have all moved up and formed a stack, but in reverse order, let us apply the Zindex modifier to move them in the correct direction.
	func zIndex(_ item: Data.Element) -> Double {
		if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
			return Double(items.count) - Double(index)
		}
		return 0
	}
	
	/// Offset and Scaling Values for each Item to make it look like a Stack
	func offset(_ proxy: GeometryProxy) -> CGFloat {
		let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
		let progress = minY / itemHeight
		let maxOffset = CGFloat(stackedDisplayCount) * offsetForEachItem
		let offset = max(min(progress * offsetForEachItem, maxOffset), 0)
		return minY < 0 ? 0 : -minY + offset
	}
	
	/// Now, we'll scale the cards to distinguish between extra cards and the active primary card.
	func scale(_ proxy: GeometryProxy) -> CGFloat {
		let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
		let progress = minY / itemHeight
		let maxScale = CGFloat(stackedDisplayCount) * scaleForEachItem
		let scale = max(min(progress * scaleForEachItem, maxScale), 0)
		return 1 - scale
	}
	
	/// Since I don't want the extra cards to have full opacity, l'd prefer that the active card be opacity 1 and the first excess card be 0.7, the second card be 0.4, and so on in a decreasing sequence.
	/// NOTE: You can skip this step if you want.
	func opacity(_ proxy: GeometryProxy) -> CGFloat {
		let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
		let progress = minY / itemHeight
		/// As you can see, just one card appears after the main card, despite the fact that two cards are needed to be displayed. This is because the opacity method's progress starts at 0, 1, 2, and so on, sort of like an index, so here 2 means 3
		/// (e.g., index 1 means the 2nd value in the array). Thus, this can be resolved by simply adding a 1 to the opacityDisplayCount.
		let opacityForItem = 1 / CGFloat(opacityDisplayCount + 1)
		let maxOpacity = CGFloat(opacityForItem) * CGFloat(opacityDisplayCount + 1)
		let opacity = max(min(progress * opacityForItem, maxOpacity), 0)
		return progress < CGFloat(opacityDisplayCount + 1) ? 1 - opacity : 0
	}
	
	/// These properties will be used to move and scale the extra cards displayed on the stack. You can adjust them to suit your particular needs.
	var offsetForEachItem: CGFloat {
		return 8
	}
	
	var scaleForEachItem: CGFloat {
		return 0.08
	}
}

#Preview {
	StackedNotificationsContentView()
}
