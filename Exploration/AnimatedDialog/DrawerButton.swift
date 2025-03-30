import SwiftUI

// Drawer Source Button
struct DrawerButton: View {
	var title: String
	@Binding var config: DrawerConfig
	
	var body: some View {
		Button {
			config.hideSourceButton = true
			withAnimation(config.animation) {
				config.isPresented = true
			}
		} label: {
			Text(title)
				.fontWeight(.semibold)
				.foregroundStyle(config.foreground)
				.padding(.vertical, 12)
				.frame(maxWidth: .infinity)
				.background(config.tint, in: config.clipShape)
		}
		.buttonStyle(ScaledButtonStyle())
		.opacity(config.hideSourceButton ? 0 : 1)
		/// To animate the drawer, we first need to extract the frame position of the source button.
		/// Fortunately, we now have the onGeometryChange modifier
		/// that provides the necessary geometry information about the view.
		/// So, let's use it to extract the source button's frame position.
		.onGeometryChange(for: CGRect.self) {
			$0.frame(in: .global)
		} action: { newValue in
			config.sourceRect = newValue
		}

	}
}

// Custom Button Style
struct ScaledButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.animation(.linear(duration: 0.1), value: configuration.isPressed)
	}
}

#Preview {
	AnimatedDialogContentView()
}
