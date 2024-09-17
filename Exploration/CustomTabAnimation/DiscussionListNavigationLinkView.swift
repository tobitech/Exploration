import SwiftUI

struct DiscussionListNavigationLinkView: View {
	var body: some View {
		ZStack {
			UnevenRoundedRectangle(
				topLeadingRadius: 12,
				bottomTrailingRadius: 12
			)
			.foregroundStyle(Color(.systemGray4))
			
			NavigationLink {
				Text("Coming soon!")
			} label: {
				HStack(alignment: .top) {
					Circle()
						.frame(width: 12)
						.foregroundStyle(.purple)
						.offset(y: 5)
					
					VStack(alignment: .leading) {
						Text("42 new posts")
						Text("Club Lobby")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					
					Spacer()
					
					DiscussionListAvatarsView()
				}
				.padding()
			}
			.padding(.trailing)
		}
	}
}
