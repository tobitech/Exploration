/*
import SwiftUI

struct ImageCropperView: View {
	@State private var image: UIImage = UIImage(named: "Pic 11")!
	@State private var cropRect: CGRect = CGRect(
		x: 50, y: 50, width: 200, height: 200)
	@State private var isDragging = false
	@State private var lastDragPosition: CGPoint? = nil
	@State private var resizingCorner: ResizingCorner? = nil

	enum ResizingCorner {
		case topLeft, topRight, bottomLeft, bottomRight
	}

	var body: some View {
		GeometryReader { geo in
			ZStack {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: geo.size.width, height: geo.size.height)
					.overlay(
						ZStack {
							Rectangle()
								.path(in: cropRect)
								.stroke(Color.yellow, lineWidth: 3)
								.gesture(dragGesture(in: geo))

							ResizableCorners(cropRect: $cropRect, geoSize: geo.size)
						}
					)
			}
		}
	}

	private func dragGesture(in geo: GeometryProxy) -> some Gesture {
		DragGesture()
			.onChanged { value in
				if let lastPosition = lastDragPosition {
					let deltaX = value.location.x - lastPosition.x
					let deltaY = value.location.y - lastPosition.y
					cropRect.origin.x += deltaX
					cropRect.origin.y += deltaY
				}
				lastDragPosition = value.location
			}
			.onEnded { _ in
				lastDragPosition = nil
			}
	}
}

struct ResizableCorners: View {
	@Binding var cropRect: CGRect
	var geoSize: CGSize

	var body: some View {
		Group {
			cornerView(for: .topLeft)
				.position(x: cropRect.minX, y: cropRect.minY)
				.gesture(resizeGesture(for: .topLeft))
			cornerView(for: .topRight)
				.position(x: cropRect.maxX, y: cropRect.minY)
				.gesture(resizeGesture(for: .topRight))
			cornerView(for: .bottomLeft)
				.position(x: cropRect.minX, y: cropRect.maxY)
				.gesture(resizeGesture(for: .bottomLeft))
			cornerView(for: .bottomRight)
				.position(x: cropRect.maxX, y: cropRect.maxY)
				.gesture(resizeGesture(for: .bottomRight))
		}
	}

	private func cornerView(for corner: ImageCropperView.ResizingCorner)
		-> some View {
		Circle()
			.fill(Color.blue)
			.frame(width: 20, height: 20)
	}

	private func resizeGesture(for corner: ImageCropperView.ResizingCorner)
		-> some Gesture {
		DragGesture()
			.onChanged { value in
				switch corner {
				case .topLeft:
					cropRect.origin.x = min(value.location.x, cropRect.maxX - 50)
					cropRect.origin.y = min(value.location.y, cropRect.maxY - 50)
					cropRect.size.width = max(cropRect.maxX - cropRect.minX, 50)
					cropRect.size.height = max(cropRect.maxY - cropRect.minY, 50)
				case .topRight:
					cropRect.size.width = max(value.location.x - cropRect.minX, 50)
					cropRect.origin.y = min(value.location.y, cropRect.maxY - 50)
					cropRect.size.height = max(cropRect.maxY - cropRect.minY, 50)
				case .bottomLeft:
					cropRect.origin.x = min(value.location.x, cropRect.maxX - 50)
					cropRect.size.width = max(cropRect.maxX - cropRect.minX, 50)
					cropRect.size.height = max(value.location.y - cropRect.minY, 50)
				case .bottomRight:
					cropRect.size.width = max(value.location.x - cropRect.minX, 50)
					cropRect.size.height = max(value.location.y - cropRect.minY, 50)
				}
			}
	}
}

#Preview {
	ImageCropperView()
}
*/
