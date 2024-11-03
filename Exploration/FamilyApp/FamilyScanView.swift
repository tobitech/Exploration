import SwiftUI

struct FamilyScanView: View {
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "flashlight.off.fill")
					.font(.title)
				Spacer()
				Image(systemName: "arrow.down.circle.fill")
					.font(.title)
			}
			Spacer()
			Text("Scan a QR code to connect with a family member")
			Spacer()
		}
		.padding()
		.background(.green)
	}
}

#Preview {
	FamilyScanView()
}
