import SwiftUI

// Extensions
extension View {
	@ViewBuilder
	func universalOverlay<Content: View>(
		animation: Animation = .snappy,
		show: Binding<Bool>,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.modifier(
				UniversalOverlayModifier(
					animation: animation,
					show: show,
					viewContent: content
				)
			)
	}
}

/// Root View Wrapper
/// In order to place views on top of the SwiftUl app, we need to create an overlay window on top of the active key window.
/// This RootView wrapper will create an overlay window, which allows us to place our views on top of the current key window.
/// To make this work, you will have to wrap your app's entry view with this wrapper.
struct UniRootView<Content: View>: View {
	var content: Content
	var properties = UniversalOverlayProperties()
	
	init(
		@ViewBuilder content: @escaping () -> Content
	) {
		self.content = content()
	}
	
	var body: some View {
		content
			.environment(properties)
			.onAppear {
				if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene), properties.window == nil {
					let window = PassthroughWindow(windowScene: windowScene) // UIWindow(windowScene: windowScene)
					window.isHidden = false
					window.isUserInteractionEnabled = true
					/// Setting up SwiftUI based root view controller.
					let rootViewController = UIHostingController(
						rootView: UniversalOverlayViews().environment(properties)
					)
					rootViewController.view.backgroundColor = .clear // .red
					window.rootViewController = rootViewController
					
					properties.window = window
				}
			}
	}
}

/// Shared Universal Overlay Properties.
@Observable
class UniversalOverlayProperties {
	var window: UIWindow?
	var views: [OverlayView] = []
	
	struct OverlayView: Identifiable {
		var id: String = UUID().uuidString
		var view: AnyView
	}
}

fileprivate struct UniversalOverlayModifier<ViewContent: View>: ViewModifier {
	var animation: Animation
	@Binding var show: Bool
	@ViewBuilder var viewContent: ViewContent
	
	// Local View Properties
	@Environment(UniversalOverlayProperties.self) private var properties
	@State private var viewID: String?
	
	func body(content: Content) -> some View {
		content
		/// Now that we've successfully set up the overlay window and made it a passthrough one, let's add and remove views to it whenever it's toggled.
			// .onChange(of: show) { oldValue, newValue in
		/// Update: YouTube video comment.
			.onChange(of: show, initial: true) { oldValue, newValue in
				if newValue {
					addView()
				} else {
					removeView()
				}
			}
	}
	
	private func addView() {
		if properties.window != nil && viewID == nil {
			viewID = UUID().uuidString
			guard let viewID else { return }
			
			withAnimation(animation) {
				properties.views.append(.init(id: viewID, view: .init(viewContent)))
			}
		}
	}
	
	private func removeView() {
		if let viewID {
			withAnimation(animation) {
				properties.views.removeAll(where: { $0.id == viewID })
			}
			
			self.viewID = nil
		}
	}
}

fileprivate struct UniversalOverlayViews: View {
	@Environment(UniversalOverlayProperties.self) private var properties
	var body: some View {
		ZStack {
			ForEach(properties.views) { $0.view }
		}
	}
}

/// As you can see, we successfully created an overlay window on top of the current active window.
/// Since it's been added on top of it, the interactions of the main key window are disabled.
/// This can be solved by making the overlay window as a pass through window, which will only be interactable if the overlay window has some views on it.
/// Otherwise, the interactions will be passed to the main window.
fileprivate class PassthroughWindow: UIWindow {
	/// Previously, before iOS 18, this code was enough to make sure to create a passthrough view/window, but from iOs 18, this code won't have interactions on the passthrough window views.
	/// Let me show you a demo of it, and then let's see how we can fix it.
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard let hitView = super.hitTest(point, with: event), let rootView = rootViewController?.view else {
			return nil
		}
		
		if #available(iOS 18, *) {
			for subview in rootView.subviews.reversed() {
				/// Finding if any of rootview's subview is receiving hit test.
				let pointInSubView = subview.convert(point, from: rootView)
				// if subview.hitTest(pointInSubView, with: event) == subview {
				// Update from YouTube video comment.
				if subview.hitTest(pointInSubView, with: event) != nil {
					return hitView
				}
			}
			return nil
		} else {
			return hitView == rootView ? nil : hitView
		}
	}
}

#Preview {
	UniRootView {
		UniversalOverlayContentView()
	}
}
