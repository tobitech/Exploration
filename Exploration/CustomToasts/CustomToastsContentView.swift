// Source - https://youtu.be/b6FVOXZT8So?si=XUAqZrS2m8WI4cYa

import SwiftUI

struct CustomToastsContentView: View {
	var body: some View {
		VStack {
			Button {
				Toast.shared.present(
					title: "AirPods Pro",
					symbol: "airpodspro",
					isUserInteractionEnabled: true,
					timing: .long
				)
			} label: {
				Text("Present Toast")
			}
		}
		.padding()
	}
}

#Preview {
	RootView {
		CustomToastsContentView()
	}
}
