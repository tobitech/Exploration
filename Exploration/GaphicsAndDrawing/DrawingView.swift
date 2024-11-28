//
//  DrawingView.swift
//  ImageStudio
//
//  Created by Oluwatobi Omotayo on 21/11/2024.
//

import SwiftUI

struct DrawingContentView: View {
	var body: some View {
		DrawingView(imageName: "Pic 3")
	}
}

struct DrawingView: View {
	let imageName: String
	@State private var currentDrawing = Drawing()
	@State private var drawings: [Drawing] = []

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				// Display the image
				Image(imageName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.overlay(
						// Apply the mask using the combined path
						MaskedImage(imageName: imageName, mask: getCombinedPath())
					)
					.gesture(
						DragGesture(minimumDistance: 0.1)
							.onChanged { value in
								let point = value.location
								currentDrawing.points.append(point)
							}
							.onEnded { _ in
								self.drawings.append(currentDrawing)
								self.currentDrawing = Drawing()
							}
					)

				// Overlay the drawn paths for visual feedback
				getCombinedPath()
					.stroke(Color.red, lineWidth: 3)
			}
		}
	}

	func getCombinedPath() -> Path {
		var path = Path()
		for drawing in drawings {
			add(drawing: drawing, toPath: &path)
		}
		add(drawing: currentDrawing, toPath: &path)
		return path
	}

	private func add(drawing: Drawing, toPath path: inout Path) {
		if let firstPoint = drawing.points.first {
			path.move(to: firstPoint)
			for point in drawing.points.dropFirst() {
				path.addLine(to: point)
			}
		}
	}
}

struct MaskedImage: View {
	let imageName: String
	let mask: Path

	var body: some View {
		Image(imageName)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.mask(
				mask
					.fill(style: FillStyle(eoFill: true))
			)
	}
}

struct Drawing {
	var points: [CGPoint] = []
}

#Preview {
	DrawingContentView()
}
