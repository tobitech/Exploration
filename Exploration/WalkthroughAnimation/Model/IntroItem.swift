import SwiftUI

struct IntroItem {
	var id = UUID()
	var text: String
	var textColor: Color
	var circleColor: Color
	var bgColor: Color
	var circleOffset: CGFloat = 0
	var textOffset: CGFloat = 0
}

// Sample Intros
/// As you can notice, the text and circle colour will be from the previous background colour (you can change it, but make the text colour more visible with the background). To make it look like a loop, I'm creating a copy of the first element at the end, and when it reaches the last element, I will simply replace it with the first element, and thus it will make a looping animation.
var sampleIntros: [IntroItem] = [
	.init(text: "Let's Create", textColor: .color4, circleColor: .color4, bgColor: .color1),
	.init(text: "Let's Brain Storm", textColor: .color1, circleColor: .color1, bgColor: .color2),
	.init(text: "Let's Explore", textColor: .color2, circleColor: .color2, bgColor: .color3),
	.init(text: "Let's Invent", textColor: .color3, circleColor: .color3, bgColor: .color4),
	.init(text: "Let's Create", textColor: .color4, circleColor: .color4, bgColor: .color1)
]
