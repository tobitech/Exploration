import SwiftUI

struct Like: Identifiable {
	var id = UUID()
	var tappedRect: CGPoint = .zero
	var isAnimated: Bool = false
}
