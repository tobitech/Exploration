//
//  CircularWheelPicker.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/09/2024.
//  Source - https://youtu.be/cl2pGJ7HYuM?si=en1WOJTL2VzomFz6

import SwiftUI

struct CircularWheelPicker: View {
	enum CircularPickerViewType {
		case wholeNumbers
		case tenths
	}
	
	@State private var radius: CGFloat = .zero
	@Binding var selection: CGFloat
	
	let from: Int
	let to: Int
	let type: CircularPickerViewType
	
	init(
		selection: Binding<CGFloat>,
		from: Int,
		to: Int,
		type: CircularPickerViewType = .wholeNumbers
	) {
		self._selection = selection
		self.from = from
		self.to = type == .wholeNumbers ? to : to * 10
		self.type = type
	}
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			ZStack {
				ScrollView(.horizontal) {
					HStack(spacing: 0) {
						Spacer(minLength: radius)
						HStack(spacing: 10) {
							ForEach(from...to, id: \.self) { number in
								Rectangle()
									.frame(width: 2, height: number % 10 == 0 ? 60 : number % 5 == 0 ? 40 : 20)
									.foregroundStyle(number % 5 == 0 ? .primary : .secondary)
									.visualEffect { content, proxy in
										content
											.rotationEffect(.degrees(-90.0 * (1 - getXPosPercentage(xPos: proxy.frame(in: .global).minX))))
											.offset(getOffset(id: type == .wholeNumbers ? CGFloat(number) : CGFloat(number) / 10, xPos: proxy.frame(in: .global).midX))
									}
							}
						}
						.frame(maxHeight: .infinity)
						.offset(y: radius / 2)
						.scrollTargetLayout()
						Spacer(minLength: radius - 2)
					}
				}
				.frame(maxHeight: radius)
				.scrollIndicators(.hidden)
				// .scrollTargetBehavior(.viewAligned)
				.mask {
					Circle()
						.frame(width: radius * 2, height: radius * 2)
						.offset(y: radius / 2)
				}
				
				VStack {
					Rectangle()
						.foregroundStyle(.red)
						.frame(width: 2, height: 50)
						.frame(width: 25)
						.overlay {
							Text(String(format: type == .wholeNumbers ? "%.0f" : "%.1f", selection))
								.font(.caption)
								.foregroundStyle(.red)
								.lineLimit(1)
								.scaledToFit()
								.minimumScaleFactor(0.1)
								.offset(y: 40)
						}
				}
				.offset(x: 1, y: -radius/2 + 25)
			}
			.frame(width: size.width, height: size.height)
			.onAppear {
				radius = min(size.width, size.height) / 2
			}
		}
	}
	
	private func getXPosPercentage(xPos: CGFloat) -> CGFloat {
		let circularArcLength = CGFloat.pi * radius / 2
		return (circularArcLength - (radius - xPos)) / circularArcLength
	}
	
	private func getOffset(id: CGFloat, xPos: CGFloat) -> CGSize {
		let xPosPercentage = getXPosPercentage(xPos: xPos)
		if xPosPercentage > 2 || xPosPercentage < 0 {
			return .zero
		}
		let angle = CGFloat.pi / 2 * xPosPercentage
		if xPosPercentage > 0.97 && xPosPercentage < 1.3 {
			DispatchQueue.main.async {
				selection = id
			}
		}
		return CGSize(width: radius - (radius * cos(angle)) - xPos, height: -radius * sin(angle))
	}
}

#Preview {
	CircularWheelPickerContentView()
}
