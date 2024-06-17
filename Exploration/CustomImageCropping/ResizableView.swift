//
//  ResizableView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 06/06/2024.
//  Source - https://stackoverflow.com/questions/74916203/how-to-resize-swiftui-views-using-a-drag-gesture-more-performant

import SwiftUI

struct CardComponentInfo: Identifiable {
	var id = UUID()
	let type: CardType
	var size: CGSize
	var origin: CGPoint
}

struct CardType {
	let color: Color
	let title: String
	let systemImageName: String
}

struct TestComponentView: View {
	
	var info: CardComponentInfo
	@ObservedObject var model: TestModel
	
	var body: some View {
		ZStack {
			Label(info.type.title, systemImage: info.type.systemImageName)
			ResizingControlsView { point, deltaX, deltaY in
				model.resizedComponentInfo = info
				model.updateForResize(using: point, deltaX: deltaX, deltaY: deltaY)
				//model.updateForResize(point: point, deltaX: deltaX, deltaY: deltaY) // other udpateForResize may work
			} dragEnded: {
				model.resizeEnded()
			}
		}
		.frame(
			width: model.widthForCardComponent(info: info),
			height: model.heightForCardComponent(info: info)
		)
		.background(info.type.color)
		.position(
			x: model.xPositionForCardComponent(info: info),
			y: model.yPositionForCardComponent(info: info)
		)
		.gesture(
			DragGesture()
				.onChanged { gesture in
					model.draggedComponentInfo = info
					model.updateForDrag(deltaX: gesture.translation.width, deltaY: gesture.translation.height)
				}
				.onEnded { _ in
					model.dragEnded()
				}
		)
	}
}

class TestModel: ObservableObject {
	
	@Published var componentInfos: [CardComponentInfo] = []
	
	@Published var draggedComponentInfo: CardComponentInfo? = nil
	@Published var dragOffset: CGSize? = nil
	
	@Published var selectedComponentInfo: CardComponentInfo? = nil
	
	// @Published var selectedTypeToAdd: CardComponentViewType? = nil
	@Published var componentBeingAddedInfo: CardComponentInfo? = nil
	
	@Published var resizedComponentInfo: CardComponentInfo? = nil
	@Published var resizeOffset: CGSize? = nil
	@Published var resizePoint: ResizePoint? = nil
	
	func widthForCardComponent(info: CardComponentInfo) -> CGFloat {
		let widthOffset = (resizedComponentInfo?.id == info.id) ? (resizeOffset?.width ?? 0.0) : 0.0
		return info.size.width + widthOffset
	}
	
	func heightForCardComponent(info: CardComponentInfo) -> CGFloat {
		let heightOffset = (resizedComponentInfo?.id == info.id) ? (resizeOffset?.height ?? 0.0) : 0.0
		return info.size.height + heightOffset
	}
	
	func xPositionForCardComponent(info: CardComponentInfo) -> CGFloat {
		let xPositionOffset = (draggedComponentInfo?.id == info.id) ? (dragOffset?.width ?? 0.0) : 0.0
		return info.origin.x + (info.size.width / 2.0) + xPositionOffset
	}
	
	func yPositionForCardComponent(info: CardComponentInfo) -> CGFloat {
		let yPositionOffset = (draggedComponentInfo?.id == info.id) ? (dragOffset?.height ?? 0.0) : 0.0
		return info.origin.y + (info.size.height / 2.0) + yPositionOffset
	}
	
	func updateForResize(point: ResizePoint, deltaX: CGFloat, deltaY: CGFloat) {
		resizeOffset = CGSize(width: deltaX, height: deltaY)
		resizePoint = resizePoint
	}
	
	func resizeEnded() {
		guard var resizedComponentInfo, var resizePoint, let resizeOffset else { return }
		var w: CGFloat = resizedComponentInfo.size.width
		var h: CGFloat = resizedComponentInfo.size.height
		var x: CGFloat = resizedComponentInfo.origin.x
		var y: CGFloat = resizedComponentInfo.origin.y
		switch resizePoint {
		case .topLeft:
			w -= resizeOffset.width
			h -= resizeOffset.height
			x += resizeOffset.width
			y += resizeOffset.height
		case .topMiddle:
			h -= resizeOffset.height
			y += resizeOffset.height
		case .topRight:
			w += resizeOffset.width
			h -= resizeOffset.height
		case .rightMiddle:
			w += resizeOffset.width
		case .bottomRight:
			w += resizeOffset.width
			h += resizeOffset.height
		case .bottomMiddle:
			h += resizeOffset.height
		case .bottomLeft:
			w -= resizeOffset.width
			h += resizeOffset.height
			x -= resizeOffset.width
			y += resizeOffset.height
		case .leftMiddle:
			w -= resizeOffset.width
			x += resizeOffset.width
		}
		resizedComponentInfo.size = CGSize(width: w, height: h)
		resizedComponentInfo.origin = CGPoint(x: x, y: y)
		self.resizeOffset = nil
		self.resizePoint = nil
		self.resizedComponentInfo = nil
	}
	
	func updateForDrag(deltaX: CGFloat, deltaY: CGFloat) {
		dragOffset = CGSize(width: deltaX, height: deltaY)
	}
	
	func dragEnded() {
		guard let dragOffset else { return }
		draggedComponentInfo?.origin.x += dragOffset.width
		draggedComponentInfo?.origin.y += dragOffset.height
		draggedComponentInfo = nil
		self.dragOffset = nil
	}
	
	func updateForResize(using resizePoint: ResizePoint, deltaX: CGFloat, deltaY: CGFloat) {
		
		guard var resizedComponentInfo else { return }
		
		var width: CGFloat = resizedComponentInfo.size.width
		var height: CGFloat = resizedComponentInfo.size.height
		var x: CGFloat = resizedComponentInfo.origin.x
		var y: CGFloat = resizedComponentInfo.origin.y
		switch resizePoint {
		case .topLeft:
			width -= deltaX
			height -= deltaY
			x += deltaX
			y += deltaY
		case .topMiddle:
			height -= deltaY
			y += deltaY
		case .topRight:
			width += deltaX
			height -= deltaY
			y += deltaY
			print(width, height, x)
		case .rightMiddle:
			width += deltaX
		case .bottomRight:
			width += deltaX
			height += deltaY
		case .bottomMiddle:
			height += deltaY
		case .bottomLeft: //
			width -= deltaX
			height += deltaY
			x += deltaX
		case .leftMiddle:
			width -= deltaX
			x += deltaX
		}
		resizedComponentInfo.size = CGSize(width: width, height: height)
		resizedComponentInfo.origin = CGPoint(x: x, y: y)
	}
}

enum ResizePoint {
	case topLeft
	case topMiddle
	case topRight
	case rightMiddle
	case bottomRight
	case bottomMiddle
	case bottomLeft
	case leftMiddle
}

struct ResizingControlsView: View {
	
	let borderColor: Color = .white
	let fillColor: Color = .blue
	let diameter: CGFloat = 15.0
	let dragged: (ResizePoint, CGFloat, CGFloat) -> Void
	let dragEnded: () -> Void
	
	var body: some View {
		VStack(spacing: 0.0) {
			HStack(spacing: 0.0) {
				grabView(resizePoint: .topLeft)
				Spacer()
				grabView(resizePoint: .topMiddle)
				Spacer()
				grabView(resizePoint: .topRight)
			}
			Spacer()
			HStack(spacing: 0.0) {
				grabView(resizePoint: .leftMiddle)
				Spacer()
				grabView(resizePoint: .rightMiddle)
			}
			Spacer()
			HStack(spacing: 0.0) {
				grabView(resizePoint: .bottomLeft)
				Spacer()
				grabView(resizePoint: .bottomMiddle)
				Spacer()
				grabView(resizePoint: .bottomRight)
			}
		}
	}
	
	private func grabView(resizePoint: ResizePoint) -> some View {
		var offsetX: CGFloat = 0.0
		var offsetY: CGFloat = 0.0
		let halfDiameter = diameter / 2.0
		switch resizePoint {
		case .topLeft:
			offsetX = -halfDiameter
			offsetY = -halfDiameter
		case .topMiddle:
			offsetY = -halfDiameter
		case .topRight:
			offsetX = halfDiameter
			offsetY = -halfDiameter
		case .rightMiddle:
			offsetX = halfDiameter
		case .bottomRight:
			offsetX = +halfDiameter
			offsetY = halfDiameter
		case .bottomMiddle:
			offsetY = halfDiameter
		case .bottomLeft:
			offsetX = -halfDiameter
			offsetY = halfDiameter
		case .leftMiddle:
			offsetX = -halfDiameter
		}
		return Circle()
			.strokeBorder(borderColor, lineWidth: 3)
			.background(Circle().foregroundColor(fillColor))
			.frame(width: diameter, height: diameter)
			.offset(x: offsetX, y: offsetY)
			.gesture(dragGesture(point: resizePoint))
	}
	
	private func dragGesture(point: ResizePoint) -> some Gesture {
		DragGesture()
			.onChanged { drag in
				switch point {
				case .topLeft:
					dragged(point, drag.translation.width, drag.translation.height)
				case .topMiddle:
					dragged(point, 0, drag.translation.height)
				case .topRight:
					dragged(point, drag.translation.width, drag.translation.height)
				case .rightMiddle:
					dragged(point, drag.translation.width, 0)
				case .bottomRight:
					dragged(point, drag.translation.width, drag.translation.height)
				case .bottomMiddle:
					dragged(point, 0, drag.translation.height)
				case .bottomLeft:
					dragged(point, drag.translation.width, drag.translation.height)
				case .leftMiddle:
					dragged(point, drag.translation.width, 0)
				}
			}
			.onEnded { _ in dragEnded() }
	}
}

#Preview {
	ZStack {
		Color.white
		TestComponentView(
			info: CardComponentInfo(type: CardType(color: .blue, title: "Some title", systemImageName: "arrow.left"), size: .init(width: 200, height: 200), origin: .init(x: 120, y: 150)),
			model: TestModel()
		)
	}
	.frame(width: .infinity, height: .infinity)
}

//@main
//struct App: App {
//
//	@StateObject private var model = TestModel()
//
//	let info = CardComponentInfo(type: .text, origin: .init(x: 300, y: 300), size: .init(width: 200, height: 200))
//
//	var body: some Scene {
//		WindowGroup("Ensemble") {
//			ZStack {
//				Color.white
//				TestComponentView(info: info, model: model)
//			}
//			.frame(width: 1000, height: 1000)
//		}
//	}
//}
