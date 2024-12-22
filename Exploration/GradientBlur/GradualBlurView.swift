//
//  GradientBlurView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 28/11/2024.
//  Source - https://youtu.be/aRWYss7-gCs?si=BNZZzEJGA0eooFq1

import SwiftUI

enum BlurDirection: Int, CaseIterable {
	case bottom = 0
	case top = 1
	case trailing = 2
	case leading = 3
	
	var unitPoints: (UnitPoint, UnitPoint) {
		return switch self {
		case .bottom:
			(.top, .bottom)
		case .top:
			(.bottom, .top)
		case .trailing:
			(.leading, .trailing)
		case .leading:
			(.trailing, .leading)
		}
	}
}

struct GradualBlurModifier: ViewModifier {
	@Environment(\.layoutDirection) var layoutDirection
	
	var radius: CGFloat
	var offset: CGFloat
	var interpolation: CGFloat
	var direction: BlurDirection
	
	func body(content: Content) -> some View {
		content
			.overlay {
				content
					.drawingGroup()
					.allowsHitTesting(false)
					.blur(radius: radius)
					.scaleEffect(1 + (radius * 0.02))
					.mask(gradientMask)
			}
	}
	
	var gradientMask: some View {
		let adjustedDirection = adjustDirectionForLayout(direction)
		let (startPoint, endPoint) = adjustedDirection.unitPoints
		
		return LinearGradient(
			stops: [
				.init(color: .clear, location: 0),
				.init(color: .clear, location: offset),
				.init(color: .black, location: offset + interpolation)
			],
			startPoint: startPoint,
			endPoint: endPoint
		)
	}
	
	private func adjustDirectionForLayout(_ direction: BlurDirection) -> BlurDirection {
		if layoutDirection == .rightToLeft {
			switch direction {
			case .leading:
				return .trailing
			case .trailing:
				return .leading
			default:
				return direction
			}
		} else {
			return direction
		}
	}
}

extension View {
	func gradualBlur(
		radius: CGFloat = 8.0,
		offset: CGFloat = 0.3,
		interpolation: CGFloat = 0.4,
		direction: BlurDirection = .bottom
	) -> some View {
		assert(radius >= 0.0, "Radius must be greater than or equal to 0.")
		assert(offset >= 0.0 && offset <= 1.0, "Offset must be between 0 and 1.")
		assert(interpolation >= 0.0 && interpolation <= 1.0, "Interpolation must be between 0 and 1.")
		
		return modifier(
			GradualBlurModifier(
				radius: radius,
				offset: offset,
				interpolation: interpolation,
				direction: direction
			)
		)
	}
}

struct GradualBlurView: View {
	@Environment(\.layoutDirection) var direction
	
	@State private var radius: CGFloat = 16
	@State private var offset: CGFloat = 0.2
	@State private var interpolation: CGFloat = 0.5
	@State private var edge: BlurDirection = .bottom
	
	var body: some View {
		VStack {
			Text("Gradual blur in SwiftUI")
				.font(.largeTitle)
				.multilineTextAlignment(.center)
			Spacer()
			Image(.pic10)
				.resizable()
				.scaledToFill()
				.frame(width: UIScreen.main.bounds.width)
				.frame(height: 400)
				.clipped()
				.gradualBlur(
					radius: radius,
					offset: offset,
					interpolation: interpolation,
					direction: edge
				)
				.overlay {
					VStack {
						HStack {
							Spacer()
							Text("China")
								.padding(8)
								.background(.ultraThinMaterial, in: .capsule)
						}
						Spacer()
						Group {
							Text("Great Wall")
								.font(.title.bold())
							Text("The Great Wall of China is a long, fortified wall stretching across northern China")
						}
						.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding()
					.foregroundStyle(.white)
				}
			
			Spacer()
			
			GroupBox("Control") {
				LabeledContent("Radius: \(radius, specifier: "%.1f")") {
					Slider(value: $radius, in: 0...20, step: 0.1)
				}
				LabeledContent("Offset: \(offset, specifier: "%.2f")") {
					Slider(value: $offset, in: 0...1, step: 0.05)
				}
				LabeledContent("Interpolation: \(interpolation, specifier: "%.1f")") {
					Slider(value: $interpolation, in: 0...1, step: 0.1)
				}
				Picker("Blur Direction", selection: $edge) {
					Text("Top")
						.tag(BlurDirection.top)
					Text("Bottom")
						.tag(BlurDirection.bottom)
					Text("Leading")
						.tag(BlurDirection.leading)
					Text("Trailing")
						.tag(BlurDirection.trailing)
				}
				.pickerStyle(.segmented)
			}
			.font(.footnote)
			.padding()
		}
	}
}

#Preview {
	GradualBlurView()
		// .environment(\.layoutDirection, .rightToLeft)
}
