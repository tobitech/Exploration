// Source - https://youtu.be/LaimspStHzk?si=K8g2E3LBz0Pf60eU

import SwiftUI

struct CustomAlertContentView: View {
	@State private var alert: AlertConfig = .init()
	var body: some View {
		Button("Show Alert", action: {
			alert.present()
		})
		.alert(alertConfig: $alert) {
			RoundedRectangle(cornerRadius: 15)
				.fill(.red.gradient)
				.frame(width: 150, height: 150)
				.onTapGesture {
					alert.dismiss()
				}
		}
	}
}

// Since Preview does not contain the SceneDelegate environment, it crashes, but to test the view, we can explicitly pass the scenedelegate class as an environment object.
// NOTE: This won't display the alerts as it's intended to just test the view; in order to test the alert, we should run it on Simulator.
#Preview {
	CustomAlertContentView()
		.environment(SceneDelegate())
}
