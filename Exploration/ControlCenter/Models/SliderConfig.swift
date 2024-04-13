import SwiftUI

// Holds all the custom slider data.
struct SliderConfig {
	var shrink: Bool = false
	var expand: Bool = false
	var showContent: Bool = false
	/// We can't use "expand" variable to animate other content because we used it for transition). Why not use "showContent"?Because it is used to show or hide the rounded rectangles. So we can animate all other content smoothly with the help of this variable.
	var animateContent: Bool = false
	var progress: CGFloat = 0
	var lastProgress: CGFloat = 0
}
