import SwiftUI

// Alert Config
struct AlertConfig {
	var enableBackgroundBlur: Bool = true
	var disableOutsideTap: Bool = true
	var transitionType: TransitionType = .slide
	var slideEdge: Edge = .bottom
	// Private Properties
	var show: Bool = true
	
	// Transition Type
	enum TransitionType {
		case slide
		case opacity
	}
	
	// Alert Present/Dismiss Methods
	mutating func present() {
		show = true
	}
	
	mutating func dismiss() {
		show = false
	}
}

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
		print("window added")
	}
	
	// The ViewTag closure will return the appropriate tag for the added alert view, and with that, we can remove the alert in some complex cases (as shown in the video).
	fileprivate func alert<Content: View>(
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
		}
	}
}

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
fileprivate struct AlertModifier<AlertContent: View>: ViewModifier {
	@Binding var config: AlertConfig
	@ViewBuilder var alertContent: () -> AlertContent
	// Scene Delegate
	@Environment(SceneDelegate.self) private var sceneDelegate
	// View Tag
	@State private var viewTag: Int = 0
	func body(content: Content) -> some View {
		content
	}
}

fileprivate struct AlertView<Content: View>: View {
	@Binding var config: AlertConfig
	// View Tag
	var tag: Int
	@ViewBuilder var content: () -> Content
	var body: some View {
		GeometryReader { geometry in
			Color.red
		}
	}
}
