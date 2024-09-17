//
//  CircularWheelPickerContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/09/2024.
//  Source - https://youtu.be/cl2pGJ7HYuM?si=b8qFOEH4-RGz_Lyc

import SwiftUI

struct CircularWheelPickerContentView: View {
	@State private var selection: CGFloat = 0
	
	var body: some View {
		CircularWheelPicker(selection: $selection, from: 0, to: 50, type: .wholeNumbers)
	}
}

#Preview {
	CircularWheelPickerContentView()
}
