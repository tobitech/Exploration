// Source - https://youtu.be/LaimspStHzk?si=K8g2E3LBz0Pf60eU

import SwiftUI

// As you can see, the alert is built with animations. Now let's test it with multiple alerts and see the results.

struct CustomAlertContentView: View {
	@State private var alert: AlertConfig = .init()
	@State private var alert1: AlertConfig = .init(slideEdge: .top)
	@State private var alert2: AlertConfig = .init(slideEdge: .leading)
	@State private var alert3: AlertConfig = .init(disableOutsideTap: false, slideEdge: .trailing)
	
	var body: some View {
		Button("Show Alert", action: {
			alert.present()
			alert1.present()
			alert2.present()
			alert3.present()
		})
		.alert(alertConfig: $alert) {
			RoundedRectangle(cornerRadius: 15)
				.fill(.red.gradient)
				.frame(width: 150, height: 150)
				.onTapGesture {
					alert.dismiss()
				}
		}
		.alert(alertConfig: $alert1) {
			RoundedRectangle(cornerRadius: 15)
				.fill(.blue.gradient)
				.frame(width: 150, height: 150)
				.onTapGesture {
					alert1.dismiss()
				}
		}
		.alert(alertConfig: $alert2) {
			RoundedRectangle(cornerRadius: 15)
				.fill(.yellow.gradient)
				.frame(width: 150, height: 150)
				.onTapGesture {
					alert1.dismiss()
				}
		}
		.alert(alertConfig: $alert3) {
			RoundedRectangle(cornerRadius: 15)
				.fill(.purple.gradient)
				.frame(width: 150, height: 150)
				.onTapGesture {
					alert1.dismiss()
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
