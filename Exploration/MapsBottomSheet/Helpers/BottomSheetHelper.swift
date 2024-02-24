//
//  BottomSheetHelper.swift
//  MapsBottomSheet
//
//  Created by Oluwatobi Omotayo on 21/02/2024.
//

import SwiftUI

extension View {
	@ViewBuilder
	// Default Tab Bar height = 49
	func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
		self
			.background(SheetRootViewFinder(mask: mask, height: height))
	}
}

// Helpers
fileprivate struct SheetRootViewFinder: UIViewRepresentable {
	var mask: Bool
	var height: CGFloat
	
	func makeUIView(context: Context) -> UIView {
		return .init()
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			if let rootView = uiView.viewBeforeWindow, let window = rootView.window {
				// As you can notice, the sheet has already moved up a little bit. The reason why it's not exactly above the tab bar is because it's having a safe area, so we have to add the safe area bottom value to exactly make the sheet start from the top of the tab bar.
				let safeArea = window.safeAreaInsets
				// Updating it's Height So that it will create a empty space in the bottom.
				rootView.frame = .init(
					origin: .zero, 
					size: CGSize(
						width: window.frame.width,
						height: window.frame.height - (mask ? (height + safeArea.bottom) : 0)
					)
				)
				
				// Now, let's remove the shadow of the sheet so that it will have an exact background to match the tab bar background (Optional).
				rootView.clipsToBounds = true
				for view in rootView.subviews {
					// Removing shadows
					view.layer.shadowColor = UIColor.clear.cgColor
					
					if view.layer.animationKeys() != nil {
						if let cornerRadiusView = view.allSubviews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
							cornerRadiusView.layer.maskedCorners = []
						}
					}
				}
			}
		}
	}
}

fileprivate extension UIView {
	// This will return the container view that is holding the sheet, and with the help of that, we can modify its sheet view as per our needs.
	var viewBeforeWindow: UIView? {
		if let superview, superview is UIWindow {
			return self
		}
		return superview?.viewBeforeWindow
	}
	
	/// Retreiving all subviews from a UIView
	var allSubviews: [UIView] {
		return subviews.flatMap { [$0] + $0.subviews }
	}
}

#Preview {
	MapsBottomSheetContentView()
}
