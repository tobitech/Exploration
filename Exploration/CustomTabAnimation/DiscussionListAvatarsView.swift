import SwiftUI

struct DiscussionListAvatarsView: View {
	var body: some View {
		ZStack {
			Circle()
				.fill(.purple)
				.stroke(Color(.systemGray4), lineWidth: 2)
				.frame(width: 27)
			
			Circle()
				.fill(.pink)
				.stroke(Color(.systemGray4), lineWidth: 2)
				.frame(width: 27)
				.offset(x: 12)
			
			Circle()
				.fill(.purple)
				.stroke(Color(.systemGray4), lineWidth: 2)
				.frame(width: 27)
				.offset(x: 24)
		}
		.frame(maxHeight: .infinity)
		.padding(.trailing)
	}
}
