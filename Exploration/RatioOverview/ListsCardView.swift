import SwiftUI

struct ListsCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			// Label("Planned list", systemImage: "list.bullet.clipboard")
			Text("Planned list")
				.font(.footnote)
				.fontWeight(.medium)
				// .textCase(.uppercase)
				.foregroundStyle(.secondary)
			VStack(alignment: .leading, spacing: 0) {
				Text("12")
					.font(.title)
					.padding(.top, 5)
				Text("items")
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			Spacer()
			HStack(alignment: .bottom) {
				Text("Completed")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
				Spacer()
				Text("8")
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
