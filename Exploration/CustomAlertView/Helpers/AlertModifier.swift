import SwiftUI

// Custom View Extensions
extension View {
	@ViewBuilder
	func alert<Content: View>(alertConfig: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content) -> some View {
		self
			.modifier(AlertModifier(config: alertConfig, alertContent: content))
	}
}

// Alert Handling View Modifier
// A private modifier that handles the present and dismisses actions for the alert
struct AlertModifier<AlertContent: View>: ViewModifier {
	@Binding var config: AlertConfig
	@ViewBuilder var alertContent: () -> AlertContent
	// Scene Delegate
	@Environment(SceneDelegate.self) private var sceneDelegate
	// View Tag
	@State private var viewTag: Int = 0
	func body(content: Content) -> some View {
		content
			.onChange(of: config.show, initial: false) { oldValue, newValue in
				if newValue {
					// print("Present")
					// Simply call the function we implemented on SceneDelegate
					sceneDelegate.alert(config: $config, content: alertContent) { tag in
						viewTag = tag
					}
				} else {
					guard let alertWindow = sceneDelegate.overlayWindow else { return }
					// print("Dismiss")
					if config.showView {
						// print("View is appeared")
						// Removing the alert with animation
						withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
							config.showView = false
						}
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
							alertWindow.rootViewController = nil
							alertWindow.isHidden = true
							alertWindow.isUserInteractionEnabled = false
						}
					} else {
						print("View is not appeared")
					}
				}
			}
	}
}
