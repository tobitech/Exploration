import SwiftUI

// Paging Slider Data Model
struct PagingItem: Identifiable {
	private(set) var id: UUID = .init()
	var color: Color
	var title: String
	var subtitle: String
}

struct CustomPagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
	// Customisation Properties
	var showsIndicator: ScrollIndicatorVisibility = .hidden
	var showPagingControl: Bool = true
	var disablePagingInteraction: Bool = true
	var titleScrollSpeed: CGFloat = 0.6
	var pagingControlSpacing: CGFloat = 20
	var spacing: CGFloat = 10
	
	@Binding var data: Item
	@ViewBuilder var content: (Binding<Item.Element>) -> Content
	@ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
	
	// View Properties
	@State private var activeID: UUID?
	
	var body: some View {
		VStack(spacing: pagingControlSpacing) {
			ScrollView(.horizontal) {
				HStack(spacing: spacing) {
					ForEach($data) { item in
						VStack(spacing: 0) {
							titleContent(item)
								.frame(maxWidth: .infinity)
								.visualEffect { content, proxy in
									content
										.offset(x: scrollOffset(proxy))
								}
							content(item)
						}
						/// As you can see, each view in the container is not taking up the full space. Previously, to make the views occupy the full available space, we needed to use views such as GeometryReader, but iOs 17 introduced a new modifier called containerRelativeFrame that eliminates the use of GeometryReader
						.containerRelativeFrame(.horizontal)
					}
				}
				// Adding paging
				.scrollTargetLayout()
			}
			.scrollIndicators(showsIndicator)
			.scrollTargetBehavior(.viewAligned)
			.scrollPosition(id: $activeID)
			
			if showPagingControl {
				PagingControl(
					numberOfPages: data.count,
					activePage: activePage,
					onPageChange: { value in
						// Updating to current page.
						if let index = value as? Item.Index, data.indices.contains(index) {
							if let id = data[index].id as? UUID {
								withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
									activeID = id
								}
							}
						}
					}
				)
				.disabled(disablePagingInteraction)
			}
		}
	}
	
	var activePage: Int {
		if let index = data.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
			return index
		}
		return 0
	}
	
	func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
		let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
		return -minX * min(titleScrollSpeed, 1.0)
	}
}

// Let's add paging control.
struct PagingControl: UIViewRepresentable {
	var numberOfPages: Int
	var activePage: Int
	var onPageChange: (Int) -> Void
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(onPageChange: onPageChange)
	}
	
	func makeUIView(context: Context) -> UIPageControl {
		let pageControl = UIPageControl()
		pageControl.numberOfPages = numberOfPages
		pageControl.currentPage = activePage
		pageControl.backgroundStyle = .prominent
		pageControl.currentPageIndicatorTintColor = UIColor(Color.primary)
		pageControl.pageIndicatorTintColor = UIColor.placeholderText
		pageControl.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
		return pageControl
	}
	
	func updateUIView(_ uiView: UIPageControl, context: Context) {
		// Updating outside event changes.
		uiView.numberOfPages = numberOfPages
		uiView.currentPage = activePage
	}
	
	class Coordinator: NSObject {
		var onPageChange: (Int) -> Void
		
		init(onPageChange: @escaping (Int) -> Void) {
			self.onPageChange = onPageChange
		}
		
		@objc func onPageUpdate(control: UIPageControl) {
			onPageChange(control.currentPage)
		}
	}
}

#Preview {
	AnimatedCarouselContentView()
}
