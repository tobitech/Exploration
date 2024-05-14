import SwiftUI

@Observable
class PhotoUICoordinator {
	var items: [TPhotoItem] = samplePhotoItems.compactMap {
		TPhotoItem(title: $0.title, image: $0.image, previewImage: $0.image)
	}
	// Animation Properties
	var selectedItem: TPhotoItem?
	var animateView: Bool = false
	var showDetailView: Bool = false
	// Scroll Positions
	/// Since the ID of the Item Model value type is a string, I'm using it as well to observe the location of the paging view.
	var detailScrollPosition: String?
	var detailIndicatorPosition: String?
	// Gesture Properties
	var offset: CGSize = .zero
	var dragProgress: CGFloat = 0
	
	func didDetailPageChanged() {
		if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
			selectedItem = updatedItem
			// Updating Indicator Position
			withAnimation(.easeInOut(duration: 0.1)) {
				detailIndicatorPosition = updatedItem.id
			}
		}
	}
	
	func didDetailIndicatorPageChanged() {
		if let updatedItem = items.first(where: { $0.id == detailIndicatorPosition }) {
			selectedItem = updatedItem
			// Updating Detail Paging View as well
			detailScrollPosition = updatedItem.id
		}
	}
	
	func toggleView(show: Bool) {
		if show {
			/// This will trigger the detail scrollview to scroll to the selected
			detailScrollPosition = selectedItem?.id
			/// This ensures that the bottom carousel always starts with the selected item.
			detailIndicatorPosition = selectedItem?.id
			withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
				animateView = true
			} completion: {
				self.showDetailView = true
			}
		} else {
			showDetailView = false
			withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
				animateView = false
				offset = .zero
			} completion: {
				self.resetAnimationProperties()
			}
		}
	}
	
	func resetAnimationProperties() {
		selectedItem = nil
		detailScrollPosition = nil
		offset = .zero
		dragProgress = 0
		detailIndicatorPosition = nil
	}
}
