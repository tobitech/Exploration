//
//  GradientBlurView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 28/11/2024.
//  Source - https://youtu.be/EFnUwG22fHk?si=VGrPvqcGnN5VRaVB

struct Blur: UIViewRepresentable {
	var style: UIBlurEffect.Style // = .systemMaterial
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}

import SwiftUI

struct GradientBlurView: View {
	var body: some View {
		ZStack {
			Image(.pic10)
				.resizable()
				.scaledToFill()
				.frame(height: 400)
				.clipped()
			Blur(style: .light)
				.frame(height: 400)
			Image(.pic10)
				.resizable()
				.scaledToFill()
				.frame(height: 400)
				.clipped()
//				.mask(
//					LinearGradient(
//						colors: [.white, .white.opacity(0)],
//						startPoint: .top,
//						endPoint: .bottom
//					)
//				)
			// Play around with the stops and location to see the cool stuffs you can generate.
				.mask(
					LinearGradient(
						stops: [
							.init(color: .white, location: 0),
							.init(color: .white, location: 0.4),
							.init(color: .white.opacity(0), location: 1.0)
						],
						startPoint: .top,
						endPoint: .bottom
					)
				)
		}
	}
}

#Preview {
	GradientBlurView()
}
