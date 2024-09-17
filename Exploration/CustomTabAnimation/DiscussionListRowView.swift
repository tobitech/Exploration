import SwiftUI

struct DiscussionListRowView: View {
	var body: some View {
		VStack {
			HStack(alignment: .top) {
				Text("Club Lobby")
					.font(.headline)
				Spacer()
				Label("42", systemImage: "message")
					.font(.subheadline)
					.foregroundStyle(.primary)
			}
			
			DiscussionListNavigationLinkView()
		}
		.padding(.vertical)
		.listRowSeparator(.hidden)
	}
}
