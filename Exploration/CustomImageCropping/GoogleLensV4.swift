import SwiftUI

struct ImageCropperView: View {
	@State private var image: UIImage =
		UIImage(named: "Pic 11") ?? UIImage(systemName: "photo")!
	@State private var cropRect: CGRect = CGRect(
		x: 50, y: 50, width: 200, height: 200)
	@State private var isDragging = false
	@State private var lastDragPosition: CGPoint? = nil
	@State private var resizingEdge: ResizingEdge? = nil
	@State private var scale: CGFloat = 1.0  // State for zoom scale
	@State private var imageOffset: CGSize = .zero  // State for image dragging offset
	@State private var lastImageDragValue: CGSize = .zero  // Separate drag position for image dragging

	// Minimum width and height for the cropping rectangle
	private let minCropWidth: CGFloat = 50
	private let minCropHeight: CGFloat = 30
	private let minZoomScale: CGFloat = 1.0
	private let maxZoomScale: CGFloat = 4.0

	enum ResizingEdge {
		case top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
	}

	var body: some View {
		GeometryReader { geo in
			ZStack {
				Color.black
					.ignoresSafeArea()
				Image(uiImage: image)
					.resizable()
					.scaledToFill()
					.frame(width: geo.size.width * scale, height: geo.size.height * scale)
					.offset(x: imageOffset.width, y: imageOffset.height)
					.gesture(pinchToZoomGesture())  // Pinch to zoom gesture
					.gesture(dragImageGesture(in: geo))  // Drag gesture for the image
					.overlay(
						ZStack {
							// Dim the area outside the crop rectangle to create a spotlight effect
							Color.black.opacity(0.5)
								.mask(
									Rectangle()
										.fill(style: FillStyle(eoFill: true))
										.frame(width: geo.size.width, height: geo.size.height)
										.overlay(
											Rectangle()
												.frame(width: cropRect.width, height: cropRect.height)
												.position(x: cropRect.midX, y: cropRect.midY)
												.blendMode(.destinationOut)
										)
								)
								.allowsHitTesting(false)

							// Draw the transparent crop rectangle
							Rectangle()
								.fill(Color.clear)
								.stroke(Color.yellow, lineWidth: 3)  // Yellow border for the crop area
								.frame(width: cropRect.width, height: cropRect.height)
								.position(x: cropRect.midX, y: cropRect.midY)
								.gesture(dragGesture(in: geo))  // Allow dragging the entire crop area

							// Draw resizable edges for the crop rectangle
							ResizableEdges(
								cropRect: $cropRect, geoSize: geo.size,
								minCropWidth: minCropWidth, minCropHeight: minCropHeight)
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
					let deltaX = value.location.x - lastPosition.x
					let deltaY = value.location.y - lastPosition.y

					// Update the origin of the crop rectangle, ensuring it stays within the bounds of the image
					cropRect.origin.x = max(
						0, min(cropRect.origin.x + deltaX, geo.size.width - cropRect.width))
					cropRect.origin.y = max(
						0,
						min(cropRect.origin.y + deltaY, geo.size.height - cropRect.height))
				}
				lastDragPosition = value.location
			}
			.onEnded { _ in
				lastDragPosition = nil  // Reset the last drag position when dragging ends
			}
	}

	// Pinch to zoom gesture
	private func pinchToZoomGesture() -> some Gesture {
		MagnificationGesture()
			.onChanged { value in
				let newScale = value * scale
				scale = min(max(newScale, minZoomScale), maxZoomScale)  // Clamp the zoom scale within limits
			}
	}

	// Gesture for dragging the image within the crop rectangle bounds
	private func dragImageGesture(in geo: GeometryProxy) -> some Gesture {
		DragGesture()
			.onChanged { value in
				// Calculate the new offset
				let newOffset = CGSize(
					width: lastImageDragValue.width + value.translation.width,
					height: lastImageDragValue.height + value.translation.height
				)
				
				// Calculate the boundary limits using the spotlight frame
				let minOffsetX = (cropRect.minX - 20) - geo.size.width + cropRect.width
				let maxOffsetX = (cropRect.minX + 20)
				let minOffsetY = (cropRect.minY - 50) - geo.size.height + cropRect.height
				let maxOffsetY = (cropRect.minY - 50)
				
				// Apply the boundary limits
				imageOffset.width = min(max(newOffset.width, minOffsetX), maxOffsetX)
				imageOffset.height = min(max(newOffset.height, minOffsetY), maxOffsetY)
			}
			.onEnded { _ in
				lastImageDragValue = imageOffset  // Reset the last drag position when dragging ends
			}
	}
}

struct ResizableEdges: View {
	@Binding var cropRect: CGRect
	var geoSize: CGSize
	var minCropWidth: CGFloat
	var minCropHeight: CGFloat

	var body: some View {
		Group {
			// Create draggable edges for resizing the crop rectangle
			ForEach(ImageCropperView.ResizingEdge.allCases, id: \.self) { edge in
				edgeView(for: edge)
					.position(position(for: edge))
					.gesture(resizeGesture(for: edge))  // Gesture for resizing from each edge
			}
		}
	}

	// View for each resizable edge
	private func edgeView(for edge: ImageCropperView.ResizingEdge) -> some View {
		Rectangle()
			.fill(Color.clear)
			.frame(
				width: (edge == .top || edge == .bottom) ? cropRect.width : 20,
				height: (edge == .left || edge == .right) ? cropRect.height : 20
			)
			.contentShape(Rectangle())
	}

	// Determine the position for each resizable edge based on the crop rectangle
	private func position(for edge: ImageCropperView.ResizingEdge) -> CGPoint {
		switch edge {
		case .top:
			return CGPoint(x: cropRect.midX, y: cropRect.minY)
		case .bottom:
			return CGPoint(x: cropRect.midX, y: cropRect.maxY)
		case .left:
			return CGPoint(x: cropRect.minX, y: cropRect.midY)
		case .right:
			return CGPoint(x: cropRect.maxX, y: cropRect.midY)
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

	// Gesture for resizing the crop rectangle from each edge
	private func resizeGesture(for edge: ImageCropperView.ResizingEdge)
		-> some Gesture
	{
		DragGesture()
			.onChanged { value in
				resizeCropRect(for: edge, with: value.location)
			}
	}

	// Resize the crop rectangle based on the dragged edge
	private func resizeCropRect(
		for edge: ImageCropperView.ResizingEdge, with location: CGPoint
	) {
		switch edge {
		case .top:
			let newY = max(0, min(location.y, cropRect.maxY - minCropHeight))
			let deltaHeight = cropRect.origin.y - newY
			cropRect.origin.y = newY
			cropRect.size.height += deltaHeight
		case .bottom:
			cropRect.size.height = max(
				min(location.y, geoSize.height) - cropRect.minY, minCropHeight)
		case .left:
			let newX = max(0, min(location.x, cropRect.maxX - minCropWidth))
			let deltaWidth = cropRect.origin.x - newX
			cropRect.origin.x = newX
			cropRect.size.width += deltaWidth
		case .right:
			cropRect.size.width = max(
				min(location.x, geoSize.width) - cropRect.minX, minCropWidth)
		case .topLeft:
			let newX = max(0, min(location.x, cropRect.maxX - minCropWidth))
			let newY = max(0, min(location.y, cropRect.maxY - minCropHeight))
			let deltaWidth = cropRect.origin.x - newX
			let deltaHeight = cropRect.origin.y - newY
			cropRect.origin.x = newX
			cropRect.origin.y = newY
			cropRect.size.width += deltaWidth
			cropRect.size.height += deltaHeight
		case .topRight:
			cropRect.size.width = max(
				min(location.x, geoSize.width) - cropRect.minX, minCropWidth)
			let newY = max(0, min(location.y, cropRect.maxY - minCropHeight))
			let deltaHeight = cropRect.origin.y - newY
			cropRect.origin.y = newY
			cropRect.size.height += deltaHeight
		case .bottomLeft:
			let newX = max(0, min(location.x, cropRect.maxX - minCropWidth))
			let deltaWidth = cropRect.origin.x - newX
			cropRect.origin.x = newX
			cropRect.size.width += deltaWidth
			cropRect.size.height = max(
				min(location.y, geoSize.height) - cropRect.minY, minCropHeight)
		case .bottomRight:
			cropRect.size.width = max(
				min(location.x, geoSize.width) - cropRect.minX, minCropWidth)
			cropRect.size.height = max(
				min(location.y, geoSize.height) - cropRect.minY, minCropHeight)
		}
	}
}

// Make the ResizingEdge enum conform to CaseIterable to easily iterate over all edges
extension ImageCropperView.ResizingEdge: CaseIterable {}

#Preview {
	ImageCropperView()
}
