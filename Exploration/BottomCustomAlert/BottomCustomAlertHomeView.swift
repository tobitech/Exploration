import SwiftUI

struct BottomCustomAlertHomeView: View {
	@State private var show: Bool = false
	
	var body: some View {
		ZStack {
			HStack {
				Button("Show Alert") {
					withAnimation {
						show.toggle()
					}
				}
			}
			
			BottomCustomAlertContentView(show: $show)
		}
	}
}

#Preview {
	BottomCustomAlertHomeView()
}
