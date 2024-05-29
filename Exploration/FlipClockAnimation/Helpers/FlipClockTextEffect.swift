import SwiftUI

struct FlipClockTextEffect: View {
	@Binding var value: Int
	// Config
	var size: CGSize
	var fontSize: CGFloat
	var cornerRadius: CGFloat
	var foreground: Color
	var background: Color
	var animationDuration: CGFloat = 0.8
	
	// View Properties
	@State private var nextValue: Int = 0
	@State private var currentValue: Int = 0
	@State private var rotation: CGFloat = 0
	
	var body: some View {
		let halfHeight = size.height * 0.5
		
		/// To create a solid flip-clock effect, I divided the text view into two distinct views. This allows the text to rotate along with the top view when it is transformed.
		ZStack {
			/// Let's develop a new background view to show the next value when the top view is flipped.
			UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
			/// Because the view is rotated, the gradient effect interferes with it, therefore let's remove it.
				// .fill(background.gradient.shadow(.inner(radius: 1)))
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .top) {
					TextView(nextValue)
						.frame(width: size.width, height: size.height)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .top)
			
			UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
			/// To create a distinct border in the middle, let's apply an inner shadow to these rectangles.
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.modifier(
					RotationModifier(
						rotation: rotation,
						currentValue: currentValue,
						nextValue: nextValue,
						fontSize: fontSize,
						foreground: foreground,
						size: size
					)
				)
				.clipped()
			/// As you can see, when the view rotates, a portion of the text view transforms alongside the rectangle.
				.rotation3DEffect(
					.init(degrees: rotation),
					axis: (x: 1.0, y: 0.0, z: 0.0),
					anchor: .bottom,
					anchorZ: 0,
					perspective: 0.4
				)
				.frame(maxHeight: .infinity, alignment: .top)
				.zIndex(10)
			
			UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: cornerRadius, bottomTrailingRadius: cornerRadius, topTrailingRadius: 0)
				.fill(background.shadow(.inner(radius: 1)))
				.frame(height: halfHeight)
				.overlay(alignment: .bottom) {
					TextView(currentValue)
						.frame(width: size.width, height: size.height)
					/// It may not be obvious in the YouTube video, but when you zoom in, you will observe a tiny difference between the top and bottom views of showing the text view, which can be resolved by using the drawingGroup) modifier.
					/// This fixes the misalignment issue between the top view and the bottom one (was aligned more to the left)
						.drawingGroup()
				}
				.clipped()
				.frame(maxHeight: .infinity, alignment: .bottom)
		}
		.frame(width: size.width, height: size.height)
		/// Now that the flip effect is complete, let's write the code that will trigger the animation whenever the value is changed.
		.onChange(of: value, initial: true) { oldValue, newValue in
			currentValue = oldValue
			nextValue = newValue
			
			guard rotation == 0 else {
				currentValue = newValue
				return
			}
			
			guard oldValue != newValue else { return }
			
			/// So, if the value changes, I instantly update the next value so that the background view receives the updated value and triggers the animation that flips the view from old to new. Once the animation is finished, I will change the current value to the new value and reset the rotation to zero. By doing this, the view will animate whenever the value changes.
			/// If a value is modified during the animation period, it will be updated automatically without interfering with the flip effect.
			withAnimation(.easeInOut(duration: animationDuration), completionCriteria: .logicallyComplete) {
				rotation = -180
			} completion: {
				rotation = 0
				/// As you can see, the value is mismatching when the value is constantly updated. We can fix this by simply replacing newValue with the value property, however, because the value property is not a state or binding property, it will not have an updated value when used inside the SwiftUI View, thus, let us make it a binding property.
				// currentValue = newValue
				currentValue = value
			}

		}
//		.onTapGesture {
//			withAnimation(.easeInOut(duration: 3)) {
//				rotation = -180
//			}
//		}
	}
	
	@ViewBuilder
	func TextView(_ value: Int) -> some View {
		Text("\(value)")
			.font(.system(size: fontSize).bold())
			.foregroundStyle(foreground)
			.lineLimit(1)
	}
}

/// When rotating the view, if the rotation is more than 90 degrees, the text content needs to be updated to reflect the new value. To do that, we need to create a new ViewModifier that conforms with Animatable, since Animatable updates the declared property continuously from start to end.
/// (The default SwiftUl behaviour is that the end value will be directly reflected rather than progression).
/// We can use it to modify the text relative to the rotation value.
fileprivate struct RotationModifier: ViewModifier, Animatable {
	var rotation: CGFloat
	var currentValue: Int
	var nextValue: Int
	var fontSize: CGFloat
	var foreground: Color
	var size: CGSize
	
	var animatableData: CGFloat {
		get { rotation }
		set { rotation = newValue }
	}
	
	func body(content: Content) -> some View {
		content
			.overlay(alignment: .top) {
				Group {
					if -rotation > 90 {
						Text("\(nextValue)")
							.font(.system(size: fontSize).bold())
							.foregroundStyle(foreground)
						/// To obtain the correct orientation, we must flip the view because it has been rotated.
							.scaleEffect(x: 1, y: -1)
							.transition(.identity)
							.lineLimit(1)
					} else {
						Text("\(currentValue)")
							.font(.system(size: fontSize).bold())
							.foregroundStyle(foreground)
							.transition(.identity)
							.lineLimit(1)
					}
				}
				.frame(width: size.width, height: size.height)
				.drawingGroup()
			}
	}
}

#Preview {
	FlipClockContentView()
}
