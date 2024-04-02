import SwiftUI

struct SavingsCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Savings", systemImage: "magsafe.batterypack")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			Text("$684")
				.font(.largeTitle)
				.fontWeight(.medium)
				.padding(.top, 5)
			Spacer()
			HStack(alignment: .bottom) {
				Text("Savings to\nExpense Ratio")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
				Spacer()
				Text("0.78")
					.fontWeight(.medium)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 140)
		.padding()
		.background(Color.orange, in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
