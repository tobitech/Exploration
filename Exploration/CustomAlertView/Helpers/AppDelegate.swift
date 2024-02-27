import SwiftUI

// App Delegate
@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		// Setting Scene Delegate Class
		config.delegateClass = SceneDelegate.self
		return config
	}
}

// Scene Delegate
// The reason for the use of observable is that this will automatically inject this object as an Environment Object in our SwiftUI Lifecycle, and then we can use it directly inside our SwiftUI Views.
@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
	// Current Scene
	weak var windowScene: UIWindowScene?
	var overlayWindow: UIWindow?
	var tag: Int = 0
	var alerts: [UIView] = []
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		windowScene = scene as? UIWindowScene
		setupOverlayWindow()
	}
	
	// Adding Overlay Window to Handle all our Alerts on Top of the current Window
	private func setupOverlayWindow() {
		guard let windowScene = windowScene else { return }
		let window = UIWindow(windowScene: windowScene)
		window.isHidden = true
		window.isUserInteractionEnabled = false
		self.overlayWindow = window
	}
	
	// The ViewTag closure will return the appropriate tag for the added alert view, and with that, we can remove the alert in some complex cases (as shown in the video).
	func alert<Content: View>(
		config: Binding<AlertConfig>,
		@ViewBuilder content: @escaping () -> Content,
		viewTag: @escaping (Int) -> Void
	) {
		guard let alertWindow = overlayWindow else { return }
		
		let viewController = UIHostingController(
			rootView: AlertView(
				config: config,
				tag: tag,
				content: {
					content()
				}
			)
		)
		viewController.view.backgroundColor = .clear
		viewController.view.tag = tag
		viewTag(tag)
		tag += 1 // Since each tag must be unique for each view, it's incremented for each alert.
		
		if alertWindow.rootViewController == nil {
			alertWindow.rootViewController = viewController
			alertWindow.isHidden = false
			alertWindow.isUserInteractionEnabled = true
		} else {
			print("Existing Alert is still Present")
			// As you can see, I didn't include any logic for the second alert, thus it won't appear. Therefore, when an alert is displayed, if any additional alerts are displayed simultaneously, I'm going to save those alerts in an array and display them in the same order as the current alert when it is dismissed.
			viewController.view.frame = alertWindow.rootViewController?.view.frame ?? .zero
			alerts.append(viewController.view)
		}
	}
}
