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
				LazyHStack(spacing: 12) {
					ForEach(images) { image in
						/// Since Stack adds items on top of one another, that's why the last item is displaying first. This can be simply resolved with the help of the zindex modifier.
						let index = Double(images.firstIndex(where: { $0.id == image.id }) ?? 0)
						
						GeometryReader { // Added as part of Type 3 code.
							let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
							
							Image(image.image)
								.resizable()
								.aspectRatio(contentMode: .fill)
							/* Type 2: Parallax
							 /// Extend the image with how much shifting you've applied in the scrollTransition modifier. In my case, I shifted the view about 80, and thus I used the value `80` here.
							 .frame(width: 220 + 80)
							 .scrollTransition(.interactive, axis: .horizontal) { content, phase in
							 content
							 .offset(x: phase == .identity ? 0 : -phase.value * 80)
							 }
							 */
								.frame(width: 220, height: size.height)
								.clipShape(.rect(cornerRadius: 25))
							/* Type 1: Circular Carousel
							 .scrollTransition(.interactive, axis: .horizontal) { content, phase in
							 content
							 /// Let's make the inactive cards blurry.
							 .blur(radius: phase == .identity ? 0 : 2, opaque: false)
							 .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
							 /// Make it a circular carousel
							 .offset(y: phase == .identity ? 0 : 35)
							 .rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * 15), anchor: .bottom)
							 }
							 */
							/* Type 3: Stacked Cards */
								.scrollTransition(.interactive, axis: .horizontal) { content, phase in
									content
										.blur(radius: phase == .identity ? 0 : 2, opaque: false)
										.scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
										.offset(y: phase == .identity ? 0 : -10)
										.rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * 5), anchor: .bottomTrailing)
										.offset(x: minX < 0 ? minX / 2 : -minX)
								}
						}
						.frame(width: 220)
						.zIndex(-index)
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
