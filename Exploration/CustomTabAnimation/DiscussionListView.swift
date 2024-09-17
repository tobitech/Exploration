import SwiftUI

struct DiscussionListView: View {
	var body: some View {
		List {
			ForEach(0..<5) { _ in
				DiscussionListRowView()
			}
		}
		.listStyle(.plain)
	}
}
