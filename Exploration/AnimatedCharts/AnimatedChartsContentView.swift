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
	@State private var isAnimated: Bool = false
	@State private var trigger: Bool = false
	
	var body: some View {
		NavigationStack {
			VStack {
				Chart {
					ForEach(appDownloads) { download in
						BarMark(
							x: .value("Month", download.month),
							y: .value("Downloads", download.isAnimated ? download.value : 0)
						)
						.foregroundStyle(.red.gradient)
						.opacity(download.isAnimated ? 1 : 0)
//						LineMark(
//							x: .value("Month", download.month),
//							y: .value("Downloads", download.isAnimated ? download.value : 0)
//						)
//						.foregroundStyle(.red.gradient)
//						.opacity(download.isAnimated ? 1 : 0)
//						SectorMark(
//							angle: .value("Downloads", download.isAnimated ? download.value : 0)
//						)
//						.foregroundStyle(by: .value("Month", download.month))
//						.opacity(download.isAnimated ? 1 : 0)
					}
				}
				/// For LineMark, BarMark and AreaMark, it's a must we declare the y-axis domain range, otherwise, the animation won't work properly. For this tutorial, we are using 12,000, but you can use the array max() property to fetch the maximum value in the chart.
				.chartYScale(domain: 0...12000)
				.frame(height: 250)
				.padding()
				.background(.background, in: .rect(cornerRadius: 10))
				
				Spacer(minLength: 0)
			}
			.padding()
			.background(.gray.opacity(0.12))
			.navigationTitle("Animated Charts")
			.onAppear(perform: animateChart)
			/// The chart will now begin with an animation every time it appears on the screen.
			/// You may also add a delay to the onAppear function to delay the animation's start and you can optionally add an opacity effect to the chart markings.
			.onChange(of: trigger, initial: false) { oldValue, newValue in
				resetChartAnimation()
				animateChart()
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Trigger") {
						// Adding extra dummy data.
						appDownloads.append(contentsOf: [
							.init(date: .createDate(1, 2, 2024), value: 4700),
							.init(date: .createDate(1, 3, 2024), value: 9700),
							.init(date: .createDate(1, 4, 2024), value: 1700)
						])
						trigger.toggle()
					}
				}
			}
		}
	}
	
	/// Animated each item with a delay to create the chart animation.
	private func animateChart() {
		guard !isAnimated else { return }
		isAnimated = true
		
		/// Just like how we can update data when we pass a binding value to ForEach, we can apply the same method to change or update the data without subscripting an array with indices.
		$appDownloads.enumerated().forEach { index, element in
			
			/// Optionally, you can also limit animation after a certain index. Consider that if you have a large set of data and do not want to animate all of the elements, we can limit the animation to a specific number of indices, such as 20.
			if index > 5 {
				element.wrappedValue.isAnimated = true
			} else {
				let delay = Double(index) * 0.05
				DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
					withAnimation(.smooth) {
						element.wrappedValue.isAnimated = true
					}
				}
			}
			
		}
	}
	
	private func resetChartAnimation() {
		$appDownloads.forEach { download in
			download.wrappedValue.isAnimated = false
		}
		isAnimated = false
	}
}

#Preview {
	AnimatedChartsContentView()
}
