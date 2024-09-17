import SwiftUI

struct BookInfoButtonsView: View {
	var body: some View {
		HStack {
			Button {
				
			} label: {
				Image(systemName: "bookmark")
			}
			.font(.title2)
			
			HorizontalButtonView(label: "Sample", hasStroke: true) {
				
			}
			
			HorizontalButtonView(label: "View", hasStroke: false) {
				
			}
		}
		.foregroundStyle(.primary)
		.padding(.vertical)
	}
}
