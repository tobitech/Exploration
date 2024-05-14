/// Now, let's start creating the Hero Transition Layer, which will animate the selected item from source to destination when tapped.
import SwiftUI

struct HeroLayer: View {
	@Environment(PhotoUICoordinator.self) private var coordinator
	
	var item: TPhotoItem
	var sAnchor: Anchor<CGRect>
	var dAnchor: Anchor<CGRect>
	
	var body: some View {
		GeometryReader { proxy in
			let sRect = proxy[sAnchor]
			let dRect = proxy[dAnchor]
			let animateView = coordinator.animateView
			
			/// The layer's position and size will be dynamically updated, starting at the source and ends at the destination.
			let viewSize: CGSize = .init(
				width: animateView ? dRect.width : sRect.width,
				height: animateView ? dRect.height : sRect.height
			)
			let viewPosition: CGSize = .init(
				width: animateView ? dRect.minX : sRect.minX,
				height: animateView ? dRect.minY : sRect.minY
			)
			
			if let image = item.image,
				 // Let's hide the layer view and unhide the detail view when the layer animation is finished.
					!coordinator.showDetailView {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: animateView ? .fit : .fill)
					.frame(width: viewSize.width, height: viewSize.height)
					.clipped()
					.offset(viewPosition)
					.transition(.identity)
			}
		}
	}
}

#Preview {
	PhotosAppContentView()
}
