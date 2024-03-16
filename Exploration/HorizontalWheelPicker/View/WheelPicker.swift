//
//  WheelPicker.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 16/03/2024.
//

import SwiftUI

struct WheelPicker: View {
	/// Config
	var config: Config
	@Binding var value: CGFloat
	
	/// View Properties.
	@State private var isLoaded: Bool = false

	var body: some View {
		GeometryReader {
			let size = $0.size
			let horizontalPadding = size.width / 2
			
			ScrollView(.horizontal) {
				HStack(spacing: config.spacing) {
					let totalSteps = config.steps * config.count
					
					/// Since the ForEach ID conforms to self, which itself is an integer data type, ScrollPosition will have the same data type.
					ForEach(0...totalSteps, id: \.self) { index in
						let remainder = index % config.steps
						Divider()
							.background(remainder == 0 ? Color.primary : .gray)
							.frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
							.frame(maxHeight: 20, alignment: .bottom)
							.overlay {
								if remainder == 0 && config.showsText {
									Text("\((index / config.steps) * config.multiplier)")
										.font(.caption)
										.fontWeight(.semibold)
										.fixedSize()
										.textScale(.secondary)
										.offset(y: 20)
								}
							}
					}
				}
				.frame(height: size.height)
				.scrollTargetLayout()
			}
			.scrollIndicators(.hidden)
			/// By using the new iOs 17 Scroll APls, we can easily create the horizontal wheel picker, and we can even know which index is at the centre by using the scrollPosition API.
			.scrollTargetBehavior(.viewAligned)
			.scrollPosition(id: .init(get: {
				/// We must reverse the value to its original index value, else, the scroll position won't work properly.
				let position: Int? = isLoaded ? (Int(value) * config.steps) / config.multiplier : nil
				return position
			}, set: { newValue in
				if let newValue {
					value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
				}
			}))
			.overlay(alignment: .center, content: {
				/// It's an Indicator to highlight the active index in the Wheel Picker.
				Rectangle()
					.frame(width: 1, height: 40)
					.padding(.bottom, 20)
			})
			.safeAreaPadding(.horizontal, horizontalPadding)
			.onAppear {
				/// By default, SwiftUI ScrollPosition won't work with initial values, but there is a work around to make it work. Simply use the onAppear modifier to inform the ScrollPosition modifier to set the initial position
				if !isLoaded {
					isLoaded = true
				}
			}
		}
	}
	
	struct Config: Equatable {
		var count: Int
		var steps: Int = 10
		var spacing: CGFloat = 5
		var multiplier: Int = 10
		var showsText: Bool = true
	}
}

#Preview {
	HorizontalWheelPickerContentView()
}
