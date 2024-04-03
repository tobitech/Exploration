import SwiftUI

struct NetworthCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			// Label("Net worth", systemImage: "suitcase")
			Text("Net worth")
				.font(.footnote)
				.fontWeight(.medium)
				// .textCase(.uppercase)
				.foregroundStyle(.secondary)
			HStack {
				Text("$232k")
					.font(.title)
					//.fontWeight(.medium)
				Image(systemName: "arrow.up.right")
					.foregroundStyle(.green)
			}
				.padding(.top, 5)
			Spacer()
			Text("Doing better than last quarter")
				.font(.footnote)
				.fontWeight(.medium)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 130)
		.padding()
		.background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
