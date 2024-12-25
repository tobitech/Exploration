//
//  ScrollTransitionContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 25/12/2024.
//  Source - https://youtu.be/7SuorN7yZ-w?si=4reAVhiKJfHl9Xaq

import SwiftUI

struct ScrollTransitionContentView: View {
	var body: some View {
		GeometryReader {
			let size = $0.size

			ScrollView(.horizontal) {
				LazyHStack(spacing: 0) {
					ForEach(images) { image in
						Image(image.image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 220, height: size.height)
							.clipShape(.rect(cornerRadius: 25))
							.scrollTransition(.interactive, axis: .horizontal) { content, phase in
								content
									/// Let's make the inactive cards blurry.
									.blur(radius: phase == .identity ? 0 : 2, opaque: false)
									.scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
									/// Make it a circular carousel
									.offset(y: phase == .identity ? 0 : 35)
									.rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * 15), anchor: .bottom)
							}
					}
				}
				.scrollTargetLayout()
			}
			.scrollClipDisabled()
			.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
			.scrollIndicators(.hidden)
			/// Make the scroll content start and end at the centre.
			.safeAreaPadding(.horizontal, (size.width - 220) / 2)
		}
		.frame(height: 330)
	}
}

#Preview {
	ScrollTransitionContentView()
}
