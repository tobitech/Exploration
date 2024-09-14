//
//  MeshingSlider.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 14/09/2024.
//  Source - https://www.rudrank.com/exploring-swiftui-creating-a-custom-slider-inspired-by-camera-control/

import SwiftUI

struct CustomSliderControl: View {
	@Binding var value: CGFloat
	let range: ClosedRange<Double>
	let stepCount: Int
	let colors: [Color]
	@State private var isDragging: Bool = false
	@State private var lastValue: Double
	
	init(
		value: Binding<CGFloat>,
		range: ClosedRange<Double>,
		stepCount: Int,
		colors: [Color]
	) {
		self._value = value
		self.range = range
		self.stepCount = stepCount
		self.colors = colors
		self._lastValue = State(initialValue: value.wrappedValue)
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .bottom) {
				// Background track
				Rectangle()
					.fill(Color(.systemBackground))
					.frame(height: 15)
				
				// Bar indicators
				HStack(alignment: .bottom, spacing: 6) {
					ForEach(0..<stepCount, id: \.self) { index in
						BarIndicator(
							height: self.getBarHeight(for: index),
							isHighlighted: Double(index) <= getNormalizedValue() * Double(stepCount - 1),
							isCurrentValue: self.isCurrentValue(index),
							isDragging: isDragging,
							shouldShow: Double(index) <= self.getNormalizedValue() * Double(stepCount - 1),
							colors: colors
						)
					}
				}
			}
			.frame(minHeight: 50, alignment: .bottom)
			.gesture(
				DragGesture(minimumDistance: 0)
					.onChanged { gesture in
						let newValue = self.getValue(geometry: geometry, dragLocation: gesture.location)
						self.value = min(max(self.range.lowerBound, newValue), self.range.upperBound)
						isDragging = true
						
						// Trigger haptic feedback when moving between steps
						if Int(self.value) != Int(self.lastValue) {
							HapticManager.shared.trigger(.light)
							self.lastValue = self.value
						}
					}
					.onEnded { _ in
						isDragging = false
						HapticManager.shared.trigger(.light)
					}
			)
		}
	}
	
	private func getProgress(geometry: GeometryProxy) -> CGFloat {
		let percent = (self.value - self.range.lowerBound) / (self.range.upperBound - self.range.lowerBound)
		return geometry.size.width * CGFloat(percent)
	}
	
	private func getBarHeight(for index: Int) -> CGFloat {
		let normalizedValue = self.getNormalizedValue()
		let stepValue = Double(index) / Double(stepCount - 1)
		let difference = abs(normalizedValue - stepValue)
		let maxHeight: CGFloat = 35
		let minHeight: CGFloat = 15
		
		if difference < 0.15 {
			return maxHeight - CGFloat(difference / 0.15) * (maxHeight - minHeight)
		} else {
			return minHeight
		}
	}
	
	private func getNormalizedValue() -> Double {
		return (self.value - self.range.lowerBound) / (self.range.upperBound - self.range.lowerBound)
	}
	
	private func isCurrentValue(_ index: Int) -> Bool {
		let normalizedValue = self.getNormalizedValue()
		let stepValue = Double(index) / Double(stepCount - 1)
		return abs(normalizedValue - stepValue) < (1.0 / Double(stepCount - 1)) / 2
	}
	
	private func getValue(geometry: GeometryProxy, dragLocation: CGPoint) -> Double {
		let percent = Double(dragLocation.x / geometry.size.width)
		let value = percent * (self.range.upperBound - self.range.lowerBound) + self.range.lowerBound
		return value
	}
}

struct BarIndicator: View {
	let height: CGFloat
	let isHighlighted: Bool
	let isCurrentValue: Bool
	let isDragging: Bool
	let shouldShow: Bool
	let colors: [Color]
	
	var body: some View {
		RoundedRectangle(cornerRadius: 4)
			.fill(
				isCurrentValue ? LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top) : (isHighlighted ? LinearGradient(colors: colors.map { $0.opacity(0.75) }, startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [.primary.opacity(0.4), .primary.opacity(0.3)], startPoint: .bottom, endPoint: .top))
			)
			.frame(width: 4, height: (isDragging && shouldShow) ? height : 15)
			.animation(.bouncy, value: height)
			.animation(.bouncy, value: isDragging)
			.animation(.bouncy, value: shouldShow)
	}
}

#Preview {
	CameraControlView()
}
