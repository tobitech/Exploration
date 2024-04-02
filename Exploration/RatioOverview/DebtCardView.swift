import SwiftUI

struct DebtCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Debt", systemImage: "creditcard")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			Text("$120")
				.font(.largeTitle)
				.fontWeight(.medium)
				.padding(.top, 5)
			Spacer()
			HStack(alignment: .bottom) {
				Text("Credit score")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
				Spacer()
				Text("750")
					.fontWeight(.medium)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 140)
		.padding()
		.background(Color.pink, in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
