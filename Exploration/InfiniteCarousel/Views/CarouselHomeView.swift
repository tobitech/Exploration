import SwiftUI

struct CarouselHomeView: View {
	// View Properties
	@State private var currentPage: String = ""
	@State private var pages: [CarouselPage] = []
	
	// Infinite Carousel Properties.
	// Contains the first and last duplicate pages in front and back to create an infinite carousel.
	@State private var fakedPages: [CarouselPage] = []
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			TabView(selection: $currentPage, content:  {
				ForEach(fakedPages) { page in
					RoundedRectangle(cornerRadius: 25.0, style: .continuous)
						.fill(page.color.gradient)
						.frame(width: 300, height: size.height)
						.tag(page.id.uuidString)
						// Calculating the entire page scroll offset.
						.offsetX(currentPage == page.id.uuidString) { rect in
							/// Explanation: When a user tries to navigate to the first page, we immediately go to the last page, which is a replica of the first page. Making it appear as though there are infinite pages. The same follows for the last page too.
							
							let minX = rect.minX
							let pageOffset = minX - (size.width * CGFloat(fakeIndex(page)))
							
							// Convert PageOffset into Progress
							let pageProgress = pageOffset / size.width
							// Infinite Carousel Logic
							if -pageProgress < 1.0 {
								// Moving to the Lage page which is actually the first duplicated page.
								// Safe Check
								if fakedPages.indices.contains(fakedPages.count - 1) {
									currentPage = fakedPages[fakedPages.count - 1].id.uuidString
								}
							}
							
							if -pageProgress > CGFloat(fakedPages.count - 1) {
								// Moving to the First page which is actually the Last duplicated page.
								// Safe Check
								if fakedPages.indices.contains(1) {
									currentPage = fakedPages[1].id.uuidString
								}
							}
						}
				}
			})
			.tabViewStyle(.page(indexDisplayMode: .never))
			.overlay(alignment: .bottom) {
				PageControl(totalPages: pages.count, currentPage: originalIndex(currentPage))
					.offset(y: -15)
			}
		}
		.frame(height: 400)
		// Create some sample tabs.
		.onAppear {
			guard fakedPages.isEmpty else { return }
			for color in [Color.red, .blue, .yellow, .black, .brown] {
				pages.append(.init(color: color))
			}
			
			fakedPages.append(contentsOf: pages)
			
			if var firstPage = pages.first, var lastPage = pages.last {
				currentPage = firstPage.id.uuidString
				
				// Updating ID
				firstPage.id = .init()
				lastPage.id = .init()
				
				fakedPages.append(firstPage)
				fakedPages.insert(lastPage, at: 0)
			}
		}
	}
	
	func fakeIndex(_ of: CarouselPage) -> Int {
		return fakedPages.firstIndex(of: of) ?? 0
	}
	
	func originalIndex(_ id: String) -> Int {
		return pages.firstIndex { page in
			page.id.uuidString == id
		} ?? 0
	}
}

#Preview {
	InfiniteCarouselContentView()
}
