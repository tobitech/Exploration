//
//  MeshGradientContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/06/2024.
//  Source - https://youtu.be/Y5QnGWOsEmQ?si=Oc6835Zw2t-tITVs

import SwiftUI

/// To help understand, we'll sketch the position coordinates for each color used in the mesh gradient
struct MeshGradientContentView: View {
	
	@State private var top: [MeshPoint] = [
		.init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0)
	]
	@State private var center: [MeshPoint] = [
		.init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5)
	]
	@State private var bottom: [MeshPoint] = [
		.init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1)
	]
	
	var body: some View {
		Text("")
//		MeshGradient(
//			width: 3,
//			height: 3,
//			points: [
//				/// This is a 3x3 grid, with each color location represented by x and y values.
////				.init(0, 0), .init(0.5, 0), .init(1, 0),
////				.init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
////				.init(0, 1), .init(0.5, 1), .init(1, 1),
//				.p(top[0]), .p(top[1]), .p(top[2]),
//				.p(center[0]), .p(center[1]), .p(center[2]),
//				.p(bottom[0]), .p(bottom[1]), .p(bottom[2]),
//			],
//			colors: [
//				.red, .orange, .pink,
//				.pink, .green, .yellow,
//				.indigo, .mint, .cyan
//			]
//		)
//		.overlay {
//			GeometryReader {
//				let size = $0.size
//				
//				VStack(spacing: 0) {
//					HStack(spacing: 0) {
//						CircleView($top[0], size)
//						CircleView($top[1], size)
//						CircleView($top[2], size, true)
//					}
//					HStack(spacing: 0) {
//						CircleView($center[0], size)
//						CircleView($center[1], size)
//						CircleView($center[2], size, true)
//					}
//					.frame(maxHeight: .infinity)
//					HStack(spacing: 0) {
//						CircleView($bottom[0], size)
//						CircleView($bottom[1], size)
//						CircleView($bottom[2], size, true)
//					}
//				}
//			}
//		}
//		.coordinateSpace(.named("MESH"))
	}
	
	@ViewBuilder
	func CircleView(_ point: Binding<MeshPoint>, _ size: CGSize, _ isLast: Bool = false) -> some View {
		
		/// In order to move the circle with the user's drag location, we also need to know the translation values.
		/// Let's store the translation values and move the circle with the user's drag location.
		Circle()
			.fill(.black)
			.frame(width: 10, height: 10)
			.contentShape(.rect)
			.offset(point.wrappedValue.offset)
			.gesture(
				DragGesture(minimumDistance: 0, coordinateSpace: .named("MESH"))
					.onChanged { value in
						let location = value.location
						/// Because mesh locations must be in the range of 0 to 1, I will convert the drag location to a range of 0 to 1 by dividing x and y values by width and height values, respectively.
						let x = Float(location.x / size.width)
						let y = Float(location.y / size.height)
						
						point.wrappedValue.x = x
						point.wrappedValue.y = y
						
						let offset = value.translation
						let lastOffset = point.wrappedValue.lastOffset
						
						point.wrappedValue.offset = offset + lastOffset
					}
					.onEnded { value in
						point.wrappedValue.lastOffset = point.wrappedValue.offset
					}
			)
		
		if !isLast {
			Spacer(minLength: 0)
		}
	}
}

/// Let's make it more interesting by making the points interactive and dynamically updating the mesh gradient based on their values.
struct MeshPoint {
	var x: Float
	var y: Float
	
	init(x: Float, y: Float) {
		self.x = x
		self.y = y
	}
	
	var offset: CGSize = .zero
	var lastOffset: CGSize = .zero
}

extension SIMD2<Float> {
	static func p(_ point: MeshPoint) -> Self {
		return .init(point.x, point.y)
	}
}

/// This helper method allows us to directly use the + operator with the CGSize type.
extension CGSize {
	static func +(lhs: CGSize, rhs: CGSize) -> Self {
		return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}
}

#Preview {
	MeshGradientContentView()
}
