import SwiftUI

struct NetworthCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Net worth", systemImage: "suitcase")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			Text("$684")
				.font(.largeTitle)
				.fontWeight(.medium)
				.padding(.top, 5)
			Spacer()
			Text("Doing better than last quarter")
				.font(.footnote)
				.fontWeight(.medium)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 140)
		.padding()
		.background(Color.teal, in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
