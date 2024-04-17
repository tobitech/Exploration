import SwiftUI

struct DynamicTabIndicatorsHomeView: View {
	// View Properties
	@State private var currentTab: DynamicTab = dynamicTabs[0]
	/// Since we need to update each tab's width and its position on the screen, we're creating a state variable to do that.
	@State private var tabs: [DynamicTab] = dynamicTabs
	@State private var contentOffset: CGFloat = 0
	@State private var indicatorWidth: CGFloat = 0
	@State private var indicatorPosition: CGFloat = 0
	
	var body: some View {
		TabView(selection: $currentTab) {
			ForEach(tabs) { tab in
				GeometryReader {
					let size = $0.size
					Image(tab.title)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: size.width, height: size.height)
				}
				.clipped()
				.ignoresSafeArea()
				.offsetX(true) { rect in
					if currentTab.title == tab.title {
						contentOffset = rect.minX - (rect.width * CGFloat(index(of: tab)))
					}
					updateTabFrame(rect.width)
				}
				.tag(tab)
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.ignoresSafeArea()
		.overlay(alignment: .top) {
			TabsView()
		}
//		.overlay {
//			Text("\(contentOffset)")
//		}
		.preferredColorScheme(.dark)
	}
	
	// Calculating Tab Width & Position
	/*
	Consider we have four tabs, the input range will be the array of tabview width multiplied by their indices. for example, if the tabview width is 390.
 The inputRange value will be [0, 390, 780, 1170].
 Now we need to map these input ranges to the individual tab indicator's width in order to get the dynamic tab indicator width.
 Consider the four tab indicator widths as follows:
 outputRange = [33, 56, 30, 90]
 →
 Now consider that we need to find the indicator width when the offset is 560, so now, with the help of the linear interpolation formula, we can find the tab indicator width.
 Formula: = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
 Because 780 from the input range is closest to offset 560, it will be considered x2, and the previous value considered as x1 (390), with the same follows for y1 and y2, which is y 1 = 33 and y2 will be 56.
 x = given value (560)
 Applying Formula:
 indicatorWidth = 33 + ((56 - 33) / (780 - 390)) * (560 - 390)
 indicatorWidth = 43.025 //.
	 */
	func updateTabFrame(_ tabViewWidth: CGFloat) {
		let inputRange = tabs.indices.compactMap { index -> CGFloat? in
			return CGFloat(index) * tabViewWidth
		}
		
		let outputRangeForWidth = tabs.compactMap { tab -> CGFloat? in
			return tab.width
		}
		
		let outputRangeForPosition = tabs.compactMap { tab -> CGFloat? in
			return tab.minX
		}
		
		let widthInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForWidth)
		
		let positionInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForPosition)
		
		indicatorWidth = widthInterpolation.calculate(for: -contentOffset)
		indicatorPosition = positionInterpolation.calculate(for: -contentOffset)
	}
	
	func index(of tab: DynamicTab) -> Int {
		return tabs.firstIndex(of: tab) ?? 0
	}
	
	// Tabs View
	@ViewBuilder
	func TabsView() -> some View {
		HStack(spacing: 0) {
			ForEach($tabs) { $tab in
				Text(tab.title)
					.fontWeight(.semibold)
				// Saving Tab's minX & Width for calculation purposes.
					.offsetX(true) { rect in
						tab.minX = rect.minX
						tab.width = rect.width
					}
				
				if tabs.last != tab {
					Spacer(minLength: 0)
				}
			}
		}
		.padding([.top, .horizontal], 15)
		.overlay(alignment: .bottomLeading) {
			Rectangle()
				.frame(width: indicatorWidth, height: 5)
				.offset(x: indicatorPosition, y: 10)
		}
		.foregroundStyle(.white)
	}
}

#Preview {
	DynamicTabIndicatorsContentView()
}
