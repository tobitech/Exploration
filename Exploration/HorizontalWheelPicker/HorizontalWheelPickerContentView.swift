//
//  HorizontalWheelPickerContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 16/03/2024.
// Source - https://youtu.be/v5T_0AQkQHE?si=msX9t_Lu9JvRC47H

import SwiftUI

struct HorizontalWheelPickerContentView: View {
	@State private var config = WheelPicker.Config(count: 30)
	@State private var value: Int = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack(alignment: .lastTextBaseline, spacing: 5, content: {
					let lbs = CGFloat(config.steps) * CGFloat(value)
					Text(verbatim: "\(lbs)")
						.font(.largeTitle.bold())
						.contentTransition(.numericText(value: lbs))
						.animation(.snappy, value: lbs)
					Text("lbs")
						.font(.title2)
						.fontWeight(.semibold)
						.textScale(.secondary)
						.foregroundStyle(.secondary)
				})
				.padding(.bottom, 30)
				
				WheelPicker(config: config, value: $value)
					.frame(height: 60)
			}
			.navigationTitle("Wheel Picker")
		}
	}
}

#Preview {
	HorizontalWheelPickerContentView()
}
