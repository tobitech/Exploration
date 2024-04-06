//
//  AnimatedChartsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 06/04/2024.
// Source - https://youtu.be/rMuZ_ODipqQ?si=BI7TgYcoGLsm8frd

import Charts
import SwiftUI

struct AnimatedChartsContentView: View {
	
	// View Properties
	@State private var appDownloads: [Download] = sampleDownloads
	
	var body: some View {
		NavigationStack {
			VStack {
				Chart {
					ForEach(appDownloads) { download in
						BarMark(
							x: .value("Month", download.month),
							y: .value("Downloads", download.value)
						)
						.foregroundStyle(.red.gradient)
					}
				}
				.frame(height: 250)
				.padding()
				.background(.background, in: .rect(cornerRadius: 10))
				
				Spacer(minLength: 0)
			}
			.padding()
			.background(.gray.opacity(0.12))
			.navigationTitle("Animated Charts")
		}
	}
}

#Preview {
	AnimatedChartsContentView()
}
