//
//  OptionalModifiersContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 20/11/2024.
//  Source - https://youtu.be/XfujxPqTsj8?si=8cw_gREf2RvrW2tz

import SwiftUI

enum Effect: String, CaseIterable {
	case bounce = "Bounce"
	case breathe = "Breathe"
	case pulse = "Pulse"
	case rotate = "Rotate"
}


/// Sometimes, in our app, we need to add optional or conditionally based modifiers.
/// For instance, the symbol effect values cannot be set using a ternary operator if we want to have different effects based on choices. In such cases, we have two options: either write something like this or create a new view for this image and use that view here.
/// However, what if we could create a custom modifier that allows us to add modifiers based on conditions?
struct OptionalModifiersContentView: View {
	@State private var effect: Effect = .bounce
	
	var body: some View {
		Group {
			/*
			if effect == .bounce {
				Image(systemName: "heart.fill")
					.font(.largeTitle)
					.foregroundStyle(.red.gradient)
					.symbolEffect(.bounce)
			} else if effect == .breathe {
				Image(systemName: "heart.fill")
					.font(.largeTitle)
					.foregroundStyle(.red.gradient)
					.symbolEffect(.breathe)
			} else if effect == .pulse {
				Image(systemName: "heart.fill")
					.font(.largeTitle)
					.foregroundStyle(.red.gradient)
					.symbolEffect(.pulse)
			} else {
				Image(systemName: "heart.fill")
					.font(.largeTitle)
					.foregroundStyle(.red.gradient)
					.symbolEffect(.rotate)
			}
			*/
			Picker("", selection: $effect) {
				ForEach(Effect.allCases, id: \.self) {
					Text($0.rawValue)
						.tag($0)
				}
			}
			.pickerStyle(.segmented)
			.padding()
			
			/// We have successfully enhanced the code without creating any new views or repeating any existing codes. There are numerous examples of use cases for this modifier.
			/*
			Image(systemName: "heart.fill")
				.font(.largeTitle)
				.foregroundStyle(.red.gradient)
				.modifiers { image in
					switch effect {
					case .bounce: image.symbolEffect(.bounce)
					case .breathe: image.symbolEffect(.breathe)
					case .pulse: image.symbolEffect(.pulse)
					case .rotate: image.symbolEffect(.rotate)
					}
				}
			*/
			
			/// As I mentioned earlier, since we have passed the self, we can also access all the associated view-specific modifiers. This makes it even more powerful.
			Rectangle()
				.modifiers { rectangle in
					switch effect {
					case .bounce: rectangle.fill(.red)
					case .breathe: rectangle.fill(.blue)
					case .pulse: rectangle.fill(.purple)
					case .rotate: rectangle.fill(.black)
					}
				}
		}
	}
}

/// Since we're passing the self, we can also get the view's appropriate modifiers, such as the fill) modifier, which is only available for shapes.
/// I'll explain this with code later in the video.
extension View {
	@ViewBuilder
	func modifiers<Content: View>(
		@ViewBuilder content: @escaping (Self) -> Content
	) -> some View {
		content(self)
	}
}

#Preview {
	OptionalModifiersContentView()
}
