//
//  RangeSliderContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 26/04/2024.
//  Source - https://youtu.be/L_8BqLus4NA?si=xs-HmSj0Gcu5B0vA

import SwiftUI

struct RangeSliderContentView: View {
	// View Properties
	@State private var selection: ClosedRange<CGFloat> = 30...90
	
	var body: some View {
		NavigationStack {
			VStack {
				RangeSliderView(
					selection: $selection,
					range: -10...100,
					minimumDistance: 10
				)
				
				Text("\(Int(selection.lowerBound)):\(Int(selection.upperBound))")
					.font(.largeTitle.bold())
					.padding(.top, 10)
			}
			.padding()
			.navigationTitle("Range Slider")
		}
	}
}

// Custom View
struct RangeSliderView: View {
	@Binding var selection: ClosedRange<CGFloat>
	var range: ClosedRange<CGFloat>
	var minimumDistance: CGFloat = 0
	var tint: Color = .primary
	
	// View Properties
	@State private var slider1: GestureProperties = .init()
	@State private var slider2: GestureProperties = .init()
	@State private var indicatorWidth: CGFloat = 0
	@State private var isInitial: Bool = false
	
	var body: some View {
		GeometryReader { proxy in
			/// 30 is the total width of each slider
			let maxSliderWidth = proxy.size.width - 30
			let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
			
			ZStack(alignment: .leading) {
				Capsule()
					.fill(tint.tertiary)
					.frame(height: 5)
				// Sliders
				HStack(spacing: 0) {
					Circle()
						.fill(tint)
						.frame(width: 15, height: 15)
						.contentShape(.rect)
						.overlay(alignment: .leading) {
							Rectangle()
								.fill(tint)
								.frame(width: indicatorWidth, height: 5)
							/// Because the indicator is linked to the slider's leading side, it is causing the gap between these two sliders. Adjusting the offset value to 15 will resolve this issue, as 15 is the slider's width.
								.offset(x: 15)
								.allowsHitTesting(false)
						}
						.offset(x: slider1.offset)
						.gesture(
							DragGesture(minimumDistance: 0)
								.onChanged { value in
									// Calculating Offset
									var translation = value.translation.width + slider1.lastStoredOffset
									/// Limit slider of the first slider until the second slider.
									translation = min(max(translation, 0), slider2.offset - minimumDistance)
									slider1.offset = translation
									
									calculateNewRange(proxy.size)
								}
								.onEnded { _ in
									// Storing previous Offset
									slider1.lastStoredOffset = slider1.offset
								}
						)
					
					Circle()
						.fill(tint)
						.frame(width: 15, height: 15)
						.contentShape(.rect)
						.offset(x: slider2.offset)
						.gesture(
							DragGesture(minimumDistance: 0)
								.onChanged { value in
									// Calculating Offset
									var translation = value.translation.width + slider2.lastStoredOffset
									/// When the second slider approaches the first, dragging will be limited. This prevents both sliders from overlapping, and we want a maximum width to ensure that the second slider stops at the end of the slider view.
									translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
									slider2.offset = translation
									
									calculateNewRange(proxy.size)
								}
								.onEnded { _ in
									// Storing previous Offset
									slider2.lastStoredOffset = slider2.offset
								}
						)
				}
			}
			.frame(maxHeight: .infinity)
			.task {
				guard !isInitial else { return }
				isInitial = true
				// This line is totally optional
				try? await Task.sleep(for: .seconds(0))
				let maxWidth = proxy.size.width - 30
				
				// Converting Selection Range into Offset
				let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
				let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
				
				slider1.offset = start
				slider1.lastStoredOffset = start
				slider2.offset = end
				slider2.lastStoredOffset = end
				
				calculateNewRange(proxy.size)
			}
		}
		.frame(height: 20)
	}
	
	private func calculateNewRange(_ size: CGSize) {
		indicatorWidth = slider2.offset - slider1.offset
		// Calculating New Range Values
		let maxWidth = size.width - 30
		let startProgress = slider1.offset / maxWidth
		let endProgress = slider2.offset / maxWidth
		
		// Interpolating between upper and lower bounds.
		let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
		let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
		
		// Updating Selection
		selection = newRangeStart...newRangeEnd
	}
	
	private struct GestureProperties {
		var offset: CGFloat = 0
		var lastStoredOffset: CGFloat = 0
	}
}

#Preview {
	RangeSliderContentView()
}
