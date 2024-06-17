import SwiftUI

struct AutoScrollingHomeView: View {
	// View Properties
	@State private var activeTab: ScrollingTab = .pic1
	@State private var scrollProgress: CGFloat = .zero
	@State private var tapState: AnimationState = .init()
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			VStack(spacing: 0) {
				TabIndicatorView()
				
				TabView(selection: $activeTab) {
					ForEach(ScrollingTab.allCases, id: \.rawValue) { tab in
						TabImageView(tab)
							.tag(tab)
						/// In Swiftul Page TabView, when the page is swiped, the offset will return to zero, but there is a way to find the complete scroll offset with the help of index. Like this, totalOffset = activeTabMinX - (PageWidth * activeTabIndex)
						/// EG: Consider that the active page is the second one, and minX is -90 and pageWidth is 390. Now, totalOffset = -90 - (390 * 1) // 1 is an index. totalOffset = -480
							.offsetX(tab == activeTab) { rect in
								let minX = rect.minX
								let pageOffset = minX - (size.width * CGFloat(tab.index))
								// Converting Page Offset into Progress
								let pageProgress = pageOffset / size.width
								// Limiting Progress: Limiting the scroll progress between the first and last tab and avoiding overscrolling.
								// scrollProgress = pageProgress
								// scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
								// Simply disable when the TapState value is true.
								if !tapState.status {
									scrollProgress = max(min(pageProgress, 0), -CGFloat(MapTab.allCases.count - 1))
								}
							}
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
			}
			.ignoresSafeArea(.container, edges: .bottom)
		}
	}
	
	// Tab Indicator View
	@ViewBuilder
	func TabIndicatorView() -> some View {
		GeometryReader {
			let size = $0.size
			// We are going to display 3 tabs in the entire screen.
			// Each tab will take 1/3 of the screen width, so on a single screen
			// we are dispersing 3 tabs and moving them based on the page scroll content offset.
			let tabWidth = size.width / 3
			
			HStack(spacing: 0) {
				// Due to the observing being added to each tab, it gets multiplied.
				ForEach(ScrollingTab.allCases, id: \.rawValue) { tab in
					Text(tab.rawValue)
						.font(.title3.bold())
						.foregroundStyle(activeTab == tab ? .primary : .secondary)
						.frame(width: tabWidth)
						.contentShape(.rect)
						.onTapGesture {
							withAnimation(.easeInOut(duration: 0.3)) {
								activeTab = tab
								// Set Scroll Progress Explicitly
								scrollProgress = -CGFloat(tab.index)
								tapState.startAnimation()
							}
						}
				}
			}
			.modifier(
				// Animation callback will be triggered when it reaches the end value.
				// NB: you can change this to return the animation's progress  as well.
				AnimationEndCallBack(endValue: tapState.progress, onEnd: {
					// print("Animation Finished")
					tapState.reset()
				})
			)
			.frame(width: CGFloat(ScrollingTab.allCases.count) * tabWidth)
			// Starting at center.
			.padding(.leading, tabWidth)
			/// So when one tab is fully swiped, the progress will be -1, and when the second one is swiped, it will be -2, and so on. Thus the indicator view will move smoothly based on the adjusted progress.
			.offset(x: scrollProgress * tabWidth)
		}
		.frame(height: 50)
		.padding(.top)
	}
	
	// Image View
	@ViewBuilder
	func TabImageView(_ tab: ScrollingTab) -> some View {
		GeometryReader {
			let size = $0.size
			
			Image(tab.rawValue)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: size.width, height: size.height)
				.clipped()
		}
		.ignoresSafeArea(.container, edges: .bottom)
	}
}

#Preview {
	AutoScrollingTabContentView()
}
