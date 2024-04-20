import SwiftUI

struct ScrollableIndicatorsHomeView: View {
	// View Properties
	@State private var tabs: [TabModel] = [
		.init(id: TabModel.Tab.research),
		.init(id: TabModel.Tab.deployment),
		.init(id: TabModel.Tab.analytics),
		.init(id: TabModel.Tab.audience),
		.init(id: TabModel.Tab.privacy)
	]
	@State private var activeTab: TabModel.Tab = .research
	@State private var mainViewScrollState: TabModel.Tab?
	@State private var tabScrollState: TabModel.Tab?
	@State private var progress: CGFloat = .zero
	
	var body: some View {
		VStack(spacing: 0) {
			HeaderView()
			CustomTabBar()
			
			// Main View
			GeometryReader {
				let size = $0.size
				
				/// With iOS 17, we can now create paging views more easily than ever before. It is important to note that each tab view within the scrollview must be full screen width, else, paging will not work properly.
				ScrollView(.horizontal) {
					LazyHStack(spacing: 0) {
						// Your individual Tab Views
						ForEach(tabs) { tab in
							Text(tab.id.rawValue)
								.frame(width: size.width, height: size.height)
								.contentShape(.rect)
						}
					}
					.scrollTargetLayout()
					/// Now, let's convert the scroll offset into progress using the .rect (} modifier we built earlier. In this example, the progress will be from O to the (tab count - 1), since we will divide the offset by the screen width.
					.rect { rect in
						progress = -rect.minX / size.width
					}
				}
				// It is important to notice that the scroll position must match the precise data type of the id supplied in the ForEach loop, In this example, the id is a Tab enum, thus the main ViewScrollState property is also a Tab data type.
				.scrollPosition(id: $mainViewScrollState)
				.scrollIndicators(.hidden)
				.scrollTargetBehavior(.paging)
				// Updating the TabBar when the Page View is scrolled.
				.onChange(of: mainViewScrollState) { oldValue, newValue in
					if let newValue {
						withAnimation(.snappy) {
							tabScrollState = newValue
							activeTab = newValue
						}
					}
				}
			}
		}
	}
	
	// Header View
	@ViewBuilder
	func HeaderView() -> some View {
		HStack {
			Image("avi1")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 40)
			
			Spacer(minLength: 0)
			
			// Buttons
			Button("", systemImage: "plus.circle") {
				
			}
			.font(.title2)
			.tint(.primary)
			
			Button("", systemImage: "bell") {
				
			}
			.font(.title2)
			.tint(.primary)
			
			// Profile Button
			Button {
				
			} label: {
				Image("avi2")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30, height: 30)
					.clipShape(Circle())
			}
		}
		.padding(15)
		// Divider
		.overlay(alignment: .bottom) {
			Rectangle()
				.fill(.gray.opacity(0.3))
				.frame(height: 1)
		}
	}
	
	// Dynamic Scrollable Tab Bar
	@ViewBuilder
	func CustomTabBar() -> some View {
		ScrollView(.horizontal) {
			HStack(spacing: 20) {
				ForEach($tabs) { $tab in
					Button {
						withAnimation(.snappy) {
							activeTab = tab.id
							mainViewScrollState = tab.id
							tabScrollState = tab.id
						}
					} label: {
						Text(tab.id.rawValue)
							.padding(.vertical, 12)
							.foregroundStyle(tab.id == activeTab ? Color.primary : .secondary)
							.contentShape(.rect)
					}
					.buttonStyle(.plain)
					/// To create the dynamic sizing indicator, we need the width of each tab in order to dynamically size the indicator when scrolled.
					/// The indicator scrolls with the scroll view even when it is placed outside the scroll view because the minX value on the tab button is updated in real time, and thus the interpolation maps its values in real time, causing the indicator to move along the scroll view when scrolled.
					.rect { rect in
						tab.size = rect.size
						tab.minX = rect.minX
					}
				}
			}
			.scrollTargetLayout()
		}
		/// We simply set the get property because we just needed to update the scroll position but we don't need to set it via the binding.
		.scrollPosition(
			id: .init(
				get: { return tabScrollState },
				set: { _ in }
			),
			anchor: .center
		)
		// The page scrolling indicator
		.overlay(alignment: .bottom) {
			ZStack(alignment: .leading) {
				Rectangle()
					.fill(.gray.opacity(0.3))
					.frame(height: 1)
				
				let inputRange = tabs.indices.compactMap { CGFloat($0) }
				let outputRange = tabs.compactMap { $0.size.width }
				let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
				/// As you can see, the dynamic sizing of the indicator is working as we expected. Now let's interpolate the offset values to place the indicator in the proper spots.
				let outputPositionRange = tabs.compactMap { $0.minX }
				let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
				
				Rectangle()
					.fill(.primary)
					.frame(width: indicatorWidth, height: 1.5)
					.offset(x: indicatorPosition)
			}
		}
		.safeAreaPadding(.horizontal, 15)
		.scrollIndicators(.hidden)
	}
}

#Preview {
	ScrollableIndicatorsContentView()
}
