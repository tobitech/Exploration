//
//  FlipTransitionContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/04/2024.
//  Source - https://youtu.be/hwmDFxvUCRY?si=Ee5Pfv3WibHAJiV8

import SwiftUI

/// We generally use basic transitions like opacity, slide, push, and so on, but SwiftUl makes it easy to create custom transitions like the one in the introduction.
/// Now, let's create one for flipping between two views.

/// With SwiftUl, you can make your own unique transitions by using these easy techniques.

struct FlipTransitionContentView: View {
	@State private var showView: Bool = false
	
	var body: some View {
		NavigationStack {
			VStack {
				ZStack {
					if showView {
						RoundedRectangle(cornerRadius: 25)
							.fill(.black.gradient)
							.transition(.reverseFlip)
					} else {
						RoundedRectangle(cornerRadius: 25)
							.fill(.red.gradient)
							.transition(.flip)
					}
				}
				.frame(width: 200, height: 300)
				
				Button(showView ? "Hide" : "Reveal") {
					withAnimation(.bouncy(duration: 2)) {
						showView.toggle()
					}
				}
				.buttonStyle(.borderedProminent)
				.tint(.blue)
				.padding(.top, 30)
			}
			.padding()
			.navigationTitle("Custom Transition")
		}
	}
}

#Preview {
	FlipTransitionContentView()
}

/// Creating a custom transition is just as easy as creating a view modifier, which is commonly used to design the view. However, in this case, it serves to animate the view as needed. The progress here is used to rotate the view on the y-axis while animating.
/// The destination view is displayed before the source view is partially flipped, as you can see. The views can be hidden or unhidden when they are above or below 90 degrees using the same progress value, which solves the problem. In order to obtain progressive updates, we must conform the value to the Animatable protocol, which causes progress to progress from 0 to 1 instead of 0 or 1. This is because SwiftUl animates the values directly to their destination value rather than advancing.
struct FlipTransition: ViewModifier, Animatable {
	var progress: CGFloat = 0
	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}
	
	func body(content: Content) -> some View {
		content
		/// Progress < 0.5 means the rotation is less than 90 as the progress is multiplied by 180.
			.opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
			.rotation3DEffect(
				.init(degrees: progress * 180),
				axis: (x: 0.0, y: 1.0, z: 0.0)
			)
	}
}

/// Active refers to the animating phase,
/// whereas identity refers to the stationary phase (the idle state).
extension AnyTransition {
	static let flip: AnyTransition = .modifier(
		active: FlipTransition(progress: -1),
		identity: FlipTransition()
	)
	
	/// Now, let's create another transition that will flip in the opposite direction, resulting in the flip effect.
	static let reverseFlip: AnyTransition = .modifier(
		active: FlipTransition(progress: 1),
		identity: FlipTransition()
	)
}
