/*
import SwiftUI

struct ImageCropperView: View {
		@State private var image: UIImage = UIImage(named: "Pic 11") ?? UIImage(systemName: "photo")!
		@State private var cropRect: CGRect = CGRect(x: 50, y: 50, width: 200, height: 200)
		@State private var isDragging = false
		@State private var lastDragPosition: CGPoint? = nil
		@State private var resizingCorner: ResizingCorner? = nil

		// Minimum width and height for the cropping rectangle
		private let minCropWidth: CGFloat = 50
		private let minCropHeight: CGFloat = 30

		enum ResizingCorner {
				case topLeft, topRight, bottomLeft, bottomRight
		}

		var body: some View {
				GeometryReader { geo in
						ZStack {
								Image(uiImage: image)
										.resizable()
										.scaledToFill()
										.frame(width: geo.size.width, height: geo.size.height)
										.overlay(
												ZStack {
														// Draw the crop rectangle
														Rectangle()
															.stroke(Color.yellow, lineWidth: 3) // Yellow border for the crop area
																.frame(width: cropRect.width, height: cropRect.height)
																.position(x: cropRect.midX, y: cropRect.midY)
																.gesture(dragGesture(in: geo)) // Allow dragging the entire crop area

														// Draw resizable corners for the crop rectangle
														ResizableCorners(cropRect: $cropRect, geoSize: geo.size, minCropWidth: minCropWidth, minCropHeight: minCropHeight)
												}
										)
						}
				}
		}

		// Gesture for dragging the entire crop rectangle
		private func dragGesture(in geo: GeometryProxy) -> some Gesture {
				DragGesture()
						.onChanged { value in
								if let lastPosition = lastDragPosition {
										let deltaX = value.location.x - lastDragPosition!.x
										let deltaY = value.location.y - lastDragPosition!.y

										// Update the origin of the crop rectangle, ensuring it stays within the bounds of the image
										cropRect.origin.x = max(0, min(cropRect.origin.x + deltaX, geo.size.width - cropRect.width))
										cropRect.origin.y = max(0, min(cropRect.origin.y + deltaY, geo.size.height - cropRect.height))
								}
								lastDragPosition = value.location
						}
						.onEnded { _ in
								lastDragPosition = nil // Reset the last drag position when dragging ends
						}
		}
}

struct ResizableCorners: View {
		@Binding var cropRect: CGRect
		var geoSize: CGSize
		var minCropWidth: CGFloat
		var minCropHeight: CGFloat

		var body: some View {
				Group {
						// Create draggable corners for resizing the crop rectangle
						ForEach(ImageCropperView.ResizingCorner.allCases, id: \.self) { corner in
								cornerView(for: corner)
										.position(position(for: corner))
										.gesture(resizeGesture(for: corner)) // Gesture for resizing from each corner
						}
				}
		}

		// View for each resizable corner
		private func cornerView(for corner: ImageCropperView.ResizingCorner) -> some View {
				Circle()
						.fill(Color.blue) // Blue color for the corner handles
						.frame(width: 20, height: 20) // Size of the corner handle
		}

		// Determine the position for each corner handle based on the crop rectangle
		private func position(for corner: ImageCropperView.ResizingCorner) -> CGPoint {
				switch corner {
				case .topLeft:
						return CGPoint(x: cropRect.minX, y: cropRect.minY)
				case .topRight:
						return CGPoint(x: cropRect.maxX, y: cropRect.minY)
				case .bottomLeft:
						return CGPoint(x: cropRect.minX, y: cropRect.maxY)
				case .bottomRight:
						return CGPoint(x: cropRect.maxX, y: cropRect.maxY)
				}
		}

		// Gesture for resizing the crop rectangle from each corner
		private func resizeGesture(for corner: ImageCropperView.ResizingCorner) -> some Gesture {
				DragGesture()
						.onChanged { value in
								resizeCropRect(for: corner, with: value.location)
						}
		}

		// Resize the crop rectangle based on the dragged corner
		private func resizeCropRect(for corner: ImageCropperView.ResizingCorner, with location: CGPoint) {
				switch corner {
				case .topLeft:
						// Update origin and size, ensuring the rectangle stays within bounds and respects minimum size
						cropRect.origin.x = max(0, min(location.x, cropRect.maxX - minCropWidth))
						cropRect.origin.y = max(0, min(location.y, cropRect.maxY - minCropHeight))
						cropRect.size.width = max(cropRect.maxX - cropRect.minX, minCropWidth)
						cropRect.size.height = max(cropRect.maxY - cropRect.minY, minCropHeight)
				case .topRight:
						// Update width and height, ensuring the rectangle respects bounds and minimum size
						cropRect.size.width = max(min(location.x, geoSize.width) - cropRect.minX, minCropWidth)
						cropRect.origin.y = max(0, min(location.y, cropRect.maxY - minCropHeight))
						cropRect.size.height = max(cropRect.maxY - cropRect.minY, minCropHeight)
				case .bottomLeft:
						// Update origin and size, ensuring the rectangle respects bounds and minimum size
						cropRect.origin.x = max(0, min(location.x, cropRect.maxX - minCropWidth))
						cropRect.size.width = max(cropRect.maxX - cropRect.minX, minCropWidth)
						cropRect.size.height = max(min(location.y, geoSize.height) - cropRect.minY, minCropHeight)
				case .bottomRight:
						// Update width and height, ensuring the rectangle respects bounds and minimum size
						cropRect.size.width = max(min(location.x, geoSize.width) - cropRect.minX, minCropWidth)
						cropRect.size.height = max(min(location.y, geoSize.height) - cropRect.minY, minCropHeight)
				}
		}
}

// Make the ResizingCorner enum conform to CaseIterable to easily iterate over all corners
extension ImageCropperView.ResizingCorner: CaseIterable {}

#Preview {
	ImageCropperView()
}
*/
