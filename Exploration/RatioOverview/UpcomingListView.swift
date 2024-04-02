import SwiftUI

struct UpcomingListView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Label("Recurring", systemImage: "arrow.clockwise.circle")
				.font(.subheadline)
				.fontWeight(.medium)
				.textCase(.uppercase)
				.foregroundStyle(.secondary)
			VStack(alignment: .leading) {
				HStack {
					Text("Netflix")
					Spacer()
					Text("$5")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
				Divider()
					.padding(.top, 0)
				HStack {
					Text("Starlink")
					Spacer()
					Text("$38")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
				Divider()
					.padding(.top, 0)
				HStack {
					Text("Prepaid")
					Spacer()
					Text("$42")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
			}
			.padding(.top, 10)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 140)
		.padding()
		.background(Color.green, in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
