import SwiftUI

struct MeshingSlider: View {
	@Binding var value: CGFloat
	let colors: [Color]
	var range: ClosedRange<Double> = 0...35
	
	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			HStack {
				Image(systemName: "camera.filters")
				Text("Blur")
					.foregroundStyle(.secondary)
				Spacer()
				Text(formattedValue())
					.contentTransition(.numericText())
					.foregroundStyle(.secondary)
			}
			.padding()
			CustomSliderControl(
				value: $value.animation(
					.bouncy
				),
				range: range,
				stepCount: 35,
				colors: colors
			)
		}
	}
	
	private func formattedValue() -> String {
		let number: Float = Float(value)
		return number.formatted(.number.precision(.integerAndFractionLength(integer: 0, fraction: 0)))
	}
}

#Preview {
	CameraControlView()
}
