import SwiftUI

// Alert Config
struct AlertConfig {
	var enableBackgroundBlur: Bool = true
	var disableOutsideTap: Bool = true
	var transitionType: TransitionType = .slide
	var slideEdge: Edge = .bottom
	// Private Properties
	var show: Bool = false
	
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
