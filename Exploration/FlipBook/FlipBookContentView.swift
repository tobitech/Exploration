//
//  FlipBookContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 27/04/2024.
//  Source - https://youtu.be/8rtmvwUVZnc?si=fJLPmJJe-T3JfqNG

import SwiftUI

struct FlipBookContentView: View {
	
	// View Properties
	@State private var progress: CGFloat = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				OpenableBookView(
					config: .init(
						progress: progress
					),
					front: { size in FrontView(size) },
					insideLeft: { size in LeftView(size) },
					insideRight: { size in RightView(size) }
				)
				
				/// Sometimes we want to open this view whenever the user taps a view or a button.
				/// Let's test if it works by creating a button that, when pressed, updates the progress from 0 to 1.
				HStack(spacing: 12) {
					Slider(value: $progress)
					Button("Toggle") {
						withAnimation(.snappy(duration: 1)) {
							progress = (progress == 1.0 ? 0.2 : 1.0)
						}
					}
					.buttonStyle(.borderedProminent)
				}
				.padding(10)
				.background(.background, in: .rect(cornerRadius: 10))
				.padding(.top, 50)
				
			}
			.padding(15)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(.secondary.opacity(0.15))
			.navigationTitle("Book View")
		}
	}
	
	// Front View
	@ViewBuilder
	func FrontView(_ size: CGSize) -> some View {
		Image("book1")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.offset(y: 10.0)
			.frame(width: size.width, height: size.height)
	}
	
	// Left View
	@ViewBuilder
	func LeftView(_ size: CGSize) -> some View {
		VStack(spacing: 5) {
			Image("author1")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 100, height: 100)
				.clipShape(Circle())
				.shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
			
			Text("Tamara Bundy")
				.fontWidth(.condensed)
				.fontWeight(.bold)
				.padding(.top, 8)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.background)
	}
	
	// Right View
	@ViewBuilder
	func RightView(_ size: CGSize) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Description")
				.font(.system(size: 14))
			Text("Tamara Bundy's beautifully written debut celebrates the wonder and power of friendship: how it can be found when we least expect it and make any place a home.")
				.font(.caption)
				.foregroundStyle(.secondary)
		}
		.padding(10)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.background)
	}
}

// Interactive Book Card
/// As you can see, the front view was flipped immediately when the button was pressed.
/// This is because SwiftUl animates the value of progress from 0 to directly 1, rather than progressing from 0 to 1. However, we can solve this by using the Animatable Protocol to convert this progress into animatable data, which will cause the progress to progressively go from 0 to 1 rather than jumping directly from 0 to 1.
struct OpenableBookView<Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
	var config: Config = .init()
	
	@ViewBuilder var front: (CGSize) -> Front
	@ViewBuilder var insideLeft: (CGSize) -> InsideLeft
	@ViewBuilder var insideRight: (CGSize) -> InsideRight
	
	var animatableData: CGFloat {
		get { return config.progress }
		set { config.progress = newValue }
	}
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			// Limiting progress between 0 and 1
			let progress = max(min(config.progress, 1), 0)
			let rotation = progress * -180
			let cornerRadius = config.cornerRadius
			let shadowColor = config.shadowColor
			
			ZStack {
				insideRight(size)
					.frame(width: size.width, height: size.height)
					.clipShape(
						.rect(
							topLeadingRadius: 0,
							bottomLeadingRadius: 0,
							bottomTrailingRadius: cornerRadius,
							topTrailingRadius: cornerRadius
						)
					)
				/// As you can see, the view beneath the front view shadow is making the shadow deeper, displaying the shadow on the bottom view based on the progress value, results in the bottom view only receiving the shadow when it is opened.
					.shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
					.overlay(alignment: .leading) {
						Rectangle()
							.fill(config.dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 2)))
							.frame(width: 6)
							.offset(x: -3)
							.clipped()
					}
				
				front(size)
					.frame(width: size.width, height: size.height)
					// Disabling interaction once it's flipped
					.allowsHitTesting(-rotation < 90)
					/// When the view rotation exceeds 90 degrees (which means the front view has been flipped, we will overlay the left view on top of the front view, resulting in a book-like look.
					.overlay {
						if -rotation > 90 {
							insideLeft(size)
								.frame(width: size.width, height: size.height)
								/// Since the root view has been flipped, we need to apply negative rotations to the left view to show the contents in the right direction.
							/// Instead of using rotation, we can also use the scale effect to flip the view (negative scaling will result in flipped views).
								.scaleEffect(x: -1)
								.transition(.identity)
						}
					}
					.clipShape(
						.rect(
							topLeadingRadius: 0,
							bottomLeadingRadius: 0,
							bottomTrailingRadius: cornerRadius,
							topTrailingRadius: cornerRadius
						)
					)
					.shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
				/// Let's update the rotation anchor from the center to the leading side
				/// and let's decrease the rotation perspective to 0.3 so that it won't look like it's stretching.
					.rotation3DEffect(
						.init(degrees: rotation),
            axis: (x: 0.0, y: 1.0, z: 0.0),
						anchor: .leading,
						perspective: 0.3
					)
			}
			// Let's center the book when it is open
			.offset(x: (config.width / 2) * progress)
		}
		.frame(width: config.width, height: config.height)
	}
	
	// Configuration
	struct Config {
		var width: CGFloat = 150
		var height: CGFloat = 200
		var progress: CGFloat = 0
		var cornerRadius: CGFloat = 10
		var dividerBackground: Color = .white
		var shadowColor: Color = .black
	}
}

#Preview {
	FlipBookContentView()
}
