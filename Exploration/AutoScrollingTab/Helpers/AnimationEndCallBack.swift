import SwiftUI

/// You can notice that the animation is not working. That's because when we tap the tab, it will scroll to the selected tab, so ScrollObserver will be triggered when the content is scrolling, which is what's causing the glitchy animation. To solve this, we need to observe the animation state. When the animation is explicitly started, we need to disable the offset observer and enable it again when the animation is complete. Luckily, SwiftUl has Animatable, which will allow us to observe when the animation was ended. You can also use dispatch queue delay, but this will be more accurate.
struct AnimationState {
	var progress: CGFloat = 0 // This will be used to observe the animation ending.
	var status: Bool = false
	
	mutating func startAnimation() {
		progress = 1.0
		status = true
	}
	
	mutating func reset() {
		progress = .zero
		status = false
	}
}

struct AnimationEndCallBack<Value: VectorArithmetic>: Animatable, ViewModifier {
	var animatableData: Value {
		didSet {
			checkIfAnimationFinished()
		}
	}
	
	var endValue: Value
	var onEnd: () -> Void
	
	init(endValue: Value, onEnd: @escaping () -> Void) {
		self.endValue = endValue
		self.animatableData = endValue
		self.onEnd = onEnd
	}
	
	func body(content: Content) -> some View {
		content
	}
	
	func checkIfAnimationFinished() {
		//print(animatableData)
		if animatableData == endValue {
			DispatchQueue.main.async {
				onEnd()
			}
		}
	}
}
