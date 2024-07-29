import SwiftUI

struct WalkthroughAnimationHomeView: View {
	// View Properties
	@State private var intros: [IntroItem] = sampleIntros
	@State private var activeIntro: IntroItem?
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			
			VStack(spacing: 0) {
				if let activeIntro {
					Rectangle()
						.fill(activeIntro.bgColor)
						.padding(.bottom, -30)
						// Circle and Text
						.overlay {
							Circle()
								.fill(activeIntro.circleColor)
								.frame(width: 38, height: 38)
							/// In order to hide the excess text and make it look like it's coming from the circle, I'm simply going to use a coloured background rather than a mask.
								.background(alignment: .leading) {
									Capsule()
										.fill(activeIntro.bgColor)
										.frame(width: size.width)
								}
								.background(alignment: .leading) {
									/// The text will not be visible since it's an overlay and the base view size is just 35 pt.
									/// Thus, reading the string size with the appropriate SwiftUl font and applying it here
									Text(activeIntro.text)
										.font(.largeTitle)
										.foregroundStyle(activeIntro.textColor)
										.frame(width: textSize(activeIntro.text))
										.offset(x: 10)
										/// Moving Text based on textOffset.
										.offset(x: activeIntro.textOffset)
								}
								// Moving Circle in the opposite direction
								.offset(x: -activeIntro.circleOffset)
						}
				}
				
				// Login Buttons
				LoginButtons()
					.padding(.bottom, safeArea.bottom)
					.padding(.top, 10)
					.background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
					.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
			}
			.ignoresSafeArea()
		}
		.task {
			if activeIntro == nil {
				activeIntro = intros.first
				// Delaying 0.15s and starting animation.
				/// NOTE:
				/// It's an alternative way to dispatch queue-delay task.
				/// Don't multiply separately. It won't work; multiply with the nanosecond directly (shown later in the video).
				let nanoSeconds = UInt64(1_000_000_000 * 0.5)
				try? await Task.sleep(nanoseconds: nanoSeconds)
				animate(0)
			}
		}
	}
	
	// Login Buttons
	@ViewBuilder
	func LoginButtons() -> some View {
		VStack(spacing: 12) {
			Button(action: {}, label: {
				Label("Continue With Apple", systemImage: "applelogo")
					.foregroundStyle(.black)
					.fillButton(.white)
			})
			Button(action: {}, label: {
				Label("Continue With Phone", systemImage: "phone.fill")
					.foregroundStyle(.white)
					.fillButton(.button)
			})
			Button(action: {}, label: {
				Label("Sign Up With Email", systemImage: "envelope.fill")
					.foregroundStyle(.white)
					.fillButton(.button)
			})
			Button(action: {}, label: {
				Text("Login")
					.foregroundStyle(.white)
					.fillButton(.button)
					.shadow(color: .white, radius: 1)
			})
		}
		.padding(15)
	}
	
	// Animating Intros
	/// The main idea behind this is that we'll first use the offset animation to
///	show the current text, and then after it's finished, we'll reset the offsets to
/// make the text hidden. As the animation progresses, the circle and the
/// background colour are updated to the next intro that is available, and
/// recursion is used to display the following intro in the same manner.
	func animate(_ index: Int, _ loop: Bool = true) {
		if intros.indices.contains(index + 1) {
			// Updating Text and Text Color
			activeIntro?.text = intros[index].text
			activeIntro?.textColor = intros[index].textColor
			
			// Animating Offsets
			withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
				activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
				activeIntro?.circleOffset = -(textSize(intros[index].text) + 20) / 2
			} completion: {
				// Resetting the offset with Next Slide color change
				withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
					activeIntro?.textOffset = 0
					activeIntro?.circleOffset = 0
					activeIntro?.circleColor = intros[index + 1].circleColor
					activeIntro?.bgColor = intros[index + 1].bgColor
				} completion: {
					// Going to the next slide
					// Simply Recursion
					animate(index + 1, loop)
				}
			}
		} else {
			// Looping
			/// AS YOU CAN NOTICE, SINCE I DUPLICATED THE FIRST ELEMENT AT THE LAST, IT FINISHED AT THE EXACT SAME POSITION WHERE IT STARTED. NOW SIMPLY RESET THE ANIMATION TO ZERO INDEX IF THE LOOPING CONDITION IS TRUE.
			if loop {
				animate(0, loop)
			}
		}
	}
	
	// Get Text Size based on Font
	func textSize(_ text: String) -> CGFloat {
		return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
	}
}

#Preview {
	WalkthroughAnimationContentView()
}

// Custom Modifier
extension View {
	@ViewBuilder
	func fillButton(_ color: Color) -> some View {
		self
			.fontWeight(.semibold)
			.frame(maxWidth: .infinity)
			.padding(.vertical, 15)
			.background(color, in: .rect(cornerRadius: 15))
	}
}
