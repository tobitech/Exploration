import SwiftUI

struct HoldDownButton: View {
	// Config
	var text: String
	var paddingHorizontal: CGFloat = 25
	var paddingVertical: CGFloat = 12
	var duration: CGFloat = 1
	var scale: CGFloat = 0.95
	var background: Color
	var loadingTint: Color
	var shape: AnyShape = .init(.capsule)
	var action: () -> Void
	
	// View Properties
	@State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
	@State private var timerCount: CGFloat = 0
	@State private var progress: CGFloat = 0
	@State private var isHolding: Bool = false
	@State private var isCompleted: Bool = false
	
	var body: some View {
		Text(text)
			.padding(.horizontal, paddingHorizontal)
			.padding(.vertical, paddingVertical)
			.background {
				/// Since the views inside the GeometryReader are not using any stack, the transition is not happening, Wrapping them inside ZStack solves this issue.
				ZStack(alignment: .leading) {
					Rectangle()
						.fill(background.gradient)
					
					GeometryReader {
						let size = $0.size
						// Adding Opacity Transition
						if !isCompleted {
							Rectangle()
								.fill(loadingTint)
								.frame(width: size.width * progress)
								//.transition(.opacity)
						}
					}
				}
			}
			.clipShape(shape)
			.contentShape(shape)
			.scaleEffect(isHolding ? scale : 1)
			.animation(.snappy, value: isHolding)
			// Gestures
			.gesture(longPressGesture)
			.simultaneousGesture(dragGesture)
			// Timer
			.onReceive(timer) { _ in
				if isHolding && progress != 1 {
					timerCount += 0.01
					progress = max(min(timerCount / duration, 1), 0)
				}
			}
			// Since we only need the timer to run when the button is long-pressed and not to run at initial, we cancel the timer using the onAppear modifier.
			.onAppear(perform: cancelTimer)
	}
	
	/// The timer continues to run even after we quit holding the button. To cancel, we need to use a simultaneous drage gesture 	with a minimum distance of 0.
	/// The reason for doing this is to ensure that the gesture responds instantly when touched. With this, we can stop the timer and then revert the progress to its original state.
	var dragGesture: some Gesture {
		DragGesture(minimumDistance: 0)
			.onEnded { _ in
				guard !isCompleted else { return }
				cancelTimer()
				withAnimation(.snappy) {
					reset()
				}
			}
	}
	
	var longPressGesture: some Gesture {
		LongPressGesture(minimumDuration: duration)
			.onChanged {
				// Resetting to initial state.
				isCompleted = false
				reset()

				isHolding = $0
				addTimer()
			}
			.onEnded { status in
				isHolding = false
				cancelTimer()
				withAnimation(.easeInOut(duration: 0.2)) {
					isCompleted = status
				}
				action()
			}
	}
	
	func addTimer() {
		timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
	}
	
	func cancelTimer() {
		timer.upstream.connect().cancel()
	}
	
	func reset() {
		isHolding = false
		progress = 0
		timerCount = 0
	}
}

#Preview {
	HoldDownButtonContentView()
}
