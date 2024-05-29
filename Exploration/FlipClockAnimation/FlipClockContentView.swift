//
//  FlipClockContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 29/05/2024.
//  Source - https://youtu.be/Lekoc7QS-K4?si=Jl7RbavnFvSy9MKv

import SwiftUI

struct FlipClockContentView: View {
	@State private var timer: CGFloat = 0
	@State private var count: Int = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack {
					FlipClockTextEffect(
						value: .constant(count / 10),
						size: CGSize(
							width: 100,
							height: 150
						),
						fontSize: 70,
						cornerRadius: 10,
						foreground: .white,
						background: .red
					)
					
					FlipClockTextEffect(
						value: .constant(count % 10),
						size: CGSize(
							width: 100,
							height: 150
						),
						fontSize: 70,
						cornerRadius: 10,
						foreground: .white,
						background: .red
					)
				}
				.onReceive(Timer.publish(every: 0.01, on: .current, in: .common).autoconnect(), perform: { _ in
					timer += 0.01
					if timer >= 60 { timer = 0 }
					count = Int(timer)
				})
				
//				Button("Update") {
//					count += 1
//				}
//				.buttonStyle(.borderedProminent)
//				.tint(.blue)
//				.padding(.top, 45)
			}
			.padding()
		}
	}
}

#Preview {
	FlipClockContentView()
}
