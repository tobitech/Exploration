//
//  HoldDownButton.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 05/04/2024.
// Source - https://youtu.be/f5G1eNbuY9g?si=1dkl3sIdvZdHYreO

import SwiftUI

struct HoldDownButtonContentView: View {
	// View Properties
	@State private var count: Int = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				Text(count.formatted())
					.font(.largeTitle.bold())
				
				HoldDownButton(
					text: "Hold to Increase",
					duration: 1, 
					background: .black,
					loadingTint: .white.opacity(0.3)
				) {
						count += 1
					}
				.foregroundStyle(.white)
				.padding(.top, 45)
			}
			.padding()
			.navigationTitle("Hold Down Button")
		}
	}
}

#Preview {
	HoldDownButtonContentView()
}
