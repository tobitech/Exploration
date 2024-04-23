//
//  CircularSliderContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 23/04/2024.
//  Source - https://youtu.be/oI_zsmA_M3g?si=-486pthdaCRK1BkH

import SwiftUI

struct CircularSliderContentView: View {
	var body: some View {
		NavigationStack {
			CircularSliderHomeView()
				.navigationTitle("Trip Planner")
		}
	}
}

#Preview {
	CircularSliderContentView()
}
