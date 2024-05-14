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
	
	func didDetailPageChanged() {
		if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
			selectedItem = updatedItem
		}
	}
	
	func toggleView(show: Bool) {
		if show {
			/// This will trigger the detail scrollview to scroll to the selected
			detailScrollPosition = selectedItem?.id
			withAnimation(.easeInOut(duration: 2), completionCriteria: .removed) {
				animateView = true
			} completion: {
				self.showDetailView = true
			}
		} else {
			showDetailView = false
			withAnimation(.easeInOut(duration: 2), completionCriteria: .removed) {
				animateView = false
			} completion: {
				self.resetAnimationProperties()
			}
		}
	}
	
	func resetAnimationProperties() {
		selectedItem = nil
		detailScrollPosition = nil
	}
}
