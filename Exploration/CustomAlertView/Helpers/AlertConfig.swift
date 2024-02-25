import SwiftUI

// Alert Config
struct AlertConfig {
	var enableBackgroundBlur: Bool = true
	var disableOutsideTap: Bool = true
	var transitionType: TransitionType = .slide
	var slideEdge: Edge = .bottom
	// Private Properties
	var show: Bool = false
	// Since we need to dismiss the view with the same animation, I'm creating an extra variable in the alert configuration. With that, we can animate the alert in or out even from outside the AlertView.
	var showView: Bool = false
	
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
