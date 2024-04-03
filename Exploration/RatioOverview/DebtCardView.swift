import SwiftUI

struct DebtCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			// Label("Debt", systemImage: "creditcard")
			Text("Debt")
				.font(.footnote)
				.fontWeight(.medium)
				// .textCase(.uppercase)
				.foregroundStyle(.secondary)
			HStack {
				Text("$120")
					.font(.title)
					//.fontWeight(.medium)
					.padding(.top, 5)
				Image(systemName: "arrow.down.backward")
					.foregroundStyle(.red)
			}
			Spacer()
			HStack(alignment: .bottom) {
				Text("Credit score")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
				Spacer()
				Text("750")
					.font(.subheadline)
					.fontWeight(.medium)
			}
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
