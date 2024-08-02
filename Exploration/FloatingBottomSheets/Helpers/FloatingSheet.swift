import SwiftUI

extension View {
	@ViewBuilder
	func floatingBottomSheet<Content: View>(
		isPresented: Binding<Bool>,
		onDismiss: @escaping () -> Void = {},
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		self
			.sheet(isPresented: isPresented, onDismiss: onDismiss) {
				content()
					.presentationCornerRadius(0)
					.presentationBackground(.clear)
					.presentationDragIndicator(.hidden)
					.background(SheetShadowRemover())
			}
	}
}

/// As you can see, this is the shadow I mentioned earlier. Also, sometimes you may need the sheet to be background interactable, and in those cases, these shadows will be there, making the Ul look a bit off. Thus, let's write a small helper function to remove this shadow from the sheet background.
fileprivate struct SheetShadowRemover: UIViewRepresentable {
	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: .zero)
		view.backgroundColor = .clear
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
			if let uiSheetView = view.viewBeforeWindow {
				// a check that no view is displayed when we got a hold of the view before window which is supposed to be the sheet view.
				// uiSheetView.alpha = 0
				for view in uiSheetView.subviews {
					// Clear shadows
					view.layer.shadowColor = UIColor.clear.cgColor
				}
			}
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		
	}
}

fileprivate extension UIView {
	/// Each new sheet is added to a UlWindow, which means the view before the window is the sheet's actual view. With the help of that, we can easily remove the shadows from the sheet backgrounds.
	var viewBeforeWindow: UIView? {
		if let superview, superview is UIWindow {
			return self
		}
		return superview?.viewBeforeWindow
	}
}

#Preview {
	FloatingSheetContentView()
}
