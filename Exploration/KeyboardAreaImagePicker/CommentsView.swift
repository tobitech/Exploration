import SwiftUI

struct CommentsView: View {
	@State private var text: String = ""
	@State private var showSheet: Bool = false
	
	var body: some View {
		//					VStack{
		//							Spacer()
		//						TextField("Enter your comment", text: $text)
		//					}
		ScrollView {
			ForEach(0..<20, id: \.self) { i in
				VStack {
					HStack {
						Text("\(i + 1)")
						Spacer()
					}
					Divider()
				}
				.padding(10)
				.frame(maxWidth: .infinity)
			}
		}
		.scrollDismissesKeyboard(.interactively)
		.safeAreaInset(edge: .bottom, spacing: 0) {
			HStack {
				Button {
					showSheet = true
				} label: {
					Image(systemName: "plus")
				}
				.buttonStyle(.borderedProminent)

				// Text("Side bar content")
				TextField("Enter your comment", text: $text)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(.background)
			.sheet(isPresented: $showSheet) {
				VStack {
					Text("Sheet")
				}
				.presentationDetents([.height(336), .large])
			}
		}
	}
}

#Preview {
	CommentsView()
}
