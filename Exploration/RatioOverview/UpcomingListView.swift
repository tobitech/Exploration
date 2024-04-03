import SwiftUI

struct UpcomingListView: View {
	var body: some View {
		VStack(alignment: .leading) {
			// Label("Recurring", systemImage: "arrow.clockwise.circle")
			Text("Recurring")
				.font(.subheadline)
				.fontWeight(.medium)
				//.textCase(.uppercase)
				.foregroundStyle(.secondary)
			VStack(alignment: .leading) {
				HStack {
					Text("Netflix")
					Spacer()
					Text("$5")
						.font(.subheadline)
						.foregroundStyle(.secondary)
					Text("| Due Today")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
				Divider()
					.overlay(Color(uiColor: .systemGray4))
					.padding(.top, 0)
				HStack {
					Text("Starlink")
					Spacer()
					Text("$38")
						.font(.subheadline)
						.foregroundStyle(.secondary)
					Text("| Due 25th")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
//				Divider()
//					.padding(.top, 0)
//				HStack {
//					Text("Prepaid")
//					Spacer()
//					Text("$42")
//						.font(.subheadline)
//						.foregroundStyle(.secondary)
//				}
			}
			.padding(.top, 10)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 120)
		.padding()
		.background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
