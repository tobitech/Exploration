import Foundation
import SwiftUI

// Drawer Config
struct DrawerConfig {
	var tint: Color
	var foreground: Color
	var clipShape: AnyShape
	var animation: Animation
	var isPresented: Bool = false
	var hideSourceButton: Bool = false
	var sourceRect: CGRect = .zero
	
	init(
		tint: Color = .red,
		foreground: Color = .white,
		clipShape: AnyShape = .init(.capsule),
		animation: Animation = .snappy(
			duration: 0.35,
			extraBounce: 0
		)
	) {
		self.tint = tint
		self.foreground = foreground
		self.clipShape = clipShape
		self.animation = animation
	}
}
