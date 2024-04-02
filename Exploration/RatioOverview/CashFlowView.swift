import SwiftUI

struct CashFlowView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Spent this month",systemImage: "banknote")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			Text("$193.78")
				.font(.system(size: 40))
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.padding()
	}
}

#Preview {
	RatioContentView()
}
