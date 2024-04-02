import SwiftUI

struct ListsCardView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Planned list", systemImage: "list.bullet.clipboard")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			VStack(alignment: .leading, spacing: 0) {
				Text("12")
					.font(.largeTitle)
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
					.fontWeight(.medium)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 140)
		.padding()
		.background(Color.blue, in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
