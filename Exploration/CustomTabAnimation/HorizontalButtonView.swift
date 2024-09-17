import SwiftUI

struct HorizontalButtonView: View {
	let label: String
	let hasStroke: Bool
	let action: () -> Void
	
	var body: some View {
		Button (action: action) {
			Text(label)
				.fontWeight(.semibold)
				.foregroundStyle(hasStroke ? .primary : Color(.systemBackground))
				.padding(.vertical, 4)
				.padding(.horizontal)
		}
		.background(
			ZStack {
				Capsule()
					.foregroundStyle(hasStroke ? .clear : .primary)
				if hasStroke {
					Capsule()
						.stroke(.primary, lineWidth: 2)
				}
			}
		)
	}
}
