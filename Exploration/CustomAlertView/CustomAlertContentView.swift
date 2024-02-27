// Source - https://youtu.be/LaimspStHzk?si=K8g2E3LBz0Pf60eU

import SwiftUI

// As you can see, the alert is built with animations. Now let's test it with multiple alerts and see the results.

struct CustomAlertContentView: View {
	@State private var alert: AlertConfig = .init()
	@State private var alert1: AlertConfig = .init(slideEdge: .leading)
	
	var body: some View {
		Button("Show Alert", action: {
			alert.present()
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				alert1.present()
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				alert1.dismiss()
			}
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
	}
}

// Since Preview does not contain the SceneDelegate environment, it crashes, but to test the view, we can explicitly pass the scenedelegate class as an environment object.
// NOTE: This won't display the alerts as it's intended to just test the view; in order to test the alert, we should run it on Simulator.
#Preview {
	CustomAlertContentView()
		.environment(SceneDelegate())
}
