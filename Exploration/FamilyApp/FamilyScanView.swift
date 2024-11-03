import SwiftUI

struct FamilyScanView: View {
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "flashlight.off.fill")
					.font(.title2)
				Spacer()
				Image(systemName: "arrow.down.circle.fill")
					.font(.title2)
			}
			Spacer()
			Text("Scan a receipt to add it to your expenses")
				.multilineTextAlignment(.center)
			Spacer()
		}
		.padding()
		.background(.ultraThinMaterial)
	}
}

#Preview {
	FamilyScanView()
}
