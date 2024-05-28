//
//  ShimmerEffectContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 28/05/2024.
//  Source - https://youtu.be/yhFz_DXFxec?si=FBIdkKYJh4NkNVWp

import SwiftUI

struct ShimmerEffectContentView: View {
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("Hello World!")
					.font(.title)
					.fontWeight(.black)
					// Shimmer Effect
					// without background example
					.shimmer(.init(tint: .black.opacity(0.2), highlight: .black, blur: 5))
					// with background example
					// .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
//					.padding()
//					.background {
//						RoundedRectangle(cornerRadius: 15, style: .continuous)
//							.fill(.red.gradient)
//					}
				
				HStack(spacing: 15) {
					ForEach(["suit.heart.fill", "box.truck.badge.clock.fill",
									 "sun.max.trianglebadge.exclamationmark.fill"], id: \.self) { image in
						Image(systemName: image)
							.font(.title)
							.fontWeight(.black)
							.shimmer(ShimmerConfig(tint: .white.opacity(0.4), highlight: .white, blur: 5))
							.frame(width: 40, height: 40)
							.padding()
							.background {
								RoundedRectangle(cornerRadius: 15, style: .continuous)
									.fill(.indigo.gradient)
							}
					}
				}
				
				// Another Example
				HStack {
					Circle()
						.frame(width: 55, height: 55)
					VStack(alignment: .leading, spacing: 6) {
						RoundedRectangle(cornerRadius: 4)
							.frame(height: 10)
						RoundedRectangle(cornerRadius: 4)
							.frame(height: 10)
							.padding(.trailing, 50)
						RoundedRectangle(cornerRadius: 4)
							.frame(height: 10)
							.padding(.trailing, 100)
					}
				}
				.padding(15)
				.padding(.horizontal, 30)
				.shimmer(ShimmerConfig(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
				
				RoundedRectangle(cornerRadius: 20)
					.frame(height: 200)
					.padding()
					.shimmer(ShimmerConfig(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
			}
			.navigationTitle("Shimmer Effect")
			//.preferredColorScheme(.dark)
		}
	}
}

#Preview {
	ShimmerEffectContentView()
}
