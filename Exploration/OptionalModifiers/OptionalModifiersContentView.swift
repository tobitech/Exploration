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
			
		}
	}
}

#Preview {
	OptionalModifiersContentView()
}
