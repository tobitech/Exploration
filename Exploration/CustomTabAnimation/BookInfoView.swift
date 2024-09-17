import SwiftUI

struct BookInfoView: View {
	var body: some View {
		HStack(alignment: .top) {
			Image(.book1)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 120, height: 150)
				.padding(.leading)
			
			VStack(alignment: .leading) {
				Text("Cybernetic Sirens")
					.font(.headline)
				
				Text("Zenith Bionica")
					.font(.subheadline)
				
				BookInfoButtonsView()
			}
			
			Spacer()
		}
		.padding(.vertical)
	}
}
