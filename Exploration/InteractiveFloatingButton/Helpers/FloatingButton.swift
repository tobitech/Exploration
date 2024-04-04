import SwiftUI

/// Custom Button
struct FloatingButton<Label: View>: View {
	var buttonSize: CGFloat
	// Actions
	var actions: [FloatingAction]
	var label: (Bool) -> Label
	
	init(
		buttonSize: CGFloat = 50,
		@FloatingActionBuilder actions: @escaping () -> [FloatingAction],
		@ViewBuilder label: @escaping (Bool) -> Label
	) {
		self.buttonSize = buttonSize
		self.actions = actions()
		self.label = label
	}
	
	// View Properties
	@State private var isExpanded: Bool = false
	
	var body: some View {
		Button {
			isExpanded.toggle()
		} label: {
			label(isExpanded)
				.frame(width: buttonSize, height: buttonSize)
				.contentShape(.circle)
		}
		.buttonStyle(NoAnimationButtonStyle())
		.background {
			ZStack {
				ForEach(actions) { action in
					ActionView(action)
				}
			}
			.frame(width: buttonSize, height: buttonSize)
		}
		.animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded)
	}
	
	// Action View
	@ViewBuilder
	func ActionView(_ action: FloatingAction) -> some View {
		Button {
			action.action()
			isExpanded = false
		} label: {
			Image(systemName: action.symbol)
				.font(action.font)
				.foregroundStyle(action.tint)
				.frame(width: buttonSize, height: buttonSize)
				.background(action.background, in: .circle)
				.contentShape(.circle)
		}
		.buttonStyle(PressableButtonStyle())
		.disabled(!isExpanded)
		.rotationEffect(.init(degrees: progress(action) * -90))
		.offset(x: isExpanded ? -offset / 2 : 0)
		.rotationEffect(.init(degrees: progress(action) * 90))
	}
	/// Actions are rotated based on their indices, for example, the first item rotation is 0 and the last item rotation is 90.
	
	/// To make a cirucular pattern, move the view to the leading side and begin rotating until 90 degrees, resulting in a semi-circle shape. The offset is calculated based on the number of actions being passed.
	private var offset: CGFloat {
		let buttonSize = buttonSize + 10
		return Double(actions.count) * (actions.count == 1 ? buttonSize * 2 : (actions.count == 2 ? buttonSize * 1.25 : buttonSize))
	}
	
	private func progress(_ action: FloatingAction) -> CGFloat {
		let index = CGFloat(actions.firstIndex(where: { $0.id == action.id }) ?? 0)
		return actions.count == 1 ? 1 : index / CGFloat(actions.count - 1)
	}
}

// Custom Button Styles
fileprivate struct PressableButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
			.animation(.snappy(duration: 0.3, extraBounce: 0), value: configuration.isPressed)
	}
}

fileprivate struct NoAnimationButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

struct FloatingAction: Identifiable {
	private(set) var id = UUID()
	var symbol: String
	var font: Font = .title3
	var tint: Color = .white
	var background: Color = .black
	var action: () -> Void
}

/// SwiftUI View like Builder to get array of actions using ResultBuilder
@resultBuilder
struct FloatingActionBuilder {
	static func buildBlock(_ components: FloatingAction...) -> [FloatingAction] {
		components.compactMap { $0 }
	}
}

#Preview {
	InteractiveFloatingButtonContentView()
}
