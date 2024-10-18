//
//  ActivityRingsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 25/09/2024.
//  Source - https://youtu.be/MELS1J1pP7o?si=O6f5UtTNQNt8TnQi

import SwiftUI

struct ActivityRingsContentView: View {
	@State private var progress: CGFloat = 0.0
	
	var body: some View {
		VStack {
			Circle()
				.trim(from: 0, to: 1.0)
				.stroke(lineWidth: 15)
				.rotationEffect(Angle(degrees: 235))
				.foregroundStyle(Color(.systemGray6))
				.overlay {
					Circle()
						.trim(from: 0.0, to: min(progress, 0.2))
						.stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt, lineJoin: .round))
						.foregroundStyle(.red)
						.rotationEffect(Angle(degrees: 270.0))
						.animation(.linear, value: progress)
				}
			Spacer()
			Button { progress += 0.1 } label: {
				Text("Increment")
			}
		}
		.padding()
	}
}

#Preview {
	ActivityRingsContentView()
}
