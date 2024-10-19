import SwiftUI

struct InToast: Identifiable {
	private(set) var id: String = UUID().uuidString
	var content: AnyView
	
	init(@ViewBuilder content: @escaping (String) -> some View) {
		/// This ID can be used to remove toast from the context
		self.content = .init(content(id))
	}
	
	// View Properties
	var offsetX: CGFloat = 0
	var isDeleting: Bool = false
}

extension View {
	@ViewBuilder
	func interactiveToasts(_ toasts: Binding<[InToast]>) -> some View {
		self
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.overlay(alignment: .bottom) {
				ToastsView(toasts: toasts)
			}
	}
}

fileprivate struct ToastsView: View {
	@Binding var toasts: [InToast]
	// View Properties
	/// The toast will get switched from ZStack to VStack when it's tapped, for that purpose,
	/// we can use this state property.
	@State private var isExpanded: Bool = false
	var body: some View {
		ZStack(alignment: .bottom) {
			if isExpanded {
				Rectangle()
					.fill(.ultraThinMaterial)
					.ignoresSafeArea()
					.onTapGesture {
						isExpanded = false
					}
			}
			/// AnyLayout will seamlessly update its layout and items with animations.
			let layout = isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
			layout {
				ForEach($toasts) { $toast in
					/// We can simply reverse the index to make it as a stacked cards
					// let index = toasts.firstIndex(where: { $0.id == toast.id }) ?? 0
					let index = (toasts.count - 1) - (toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)
					toast.content
						.offset(x: toast.offsetX)
						// .transition(.asymmetric(insertion: .offset(y: 100), removal: .push(from: .top)))
					/// When we pass a smaller view than it's actual view width, the removal animation will not completely remove the toast from the screen, and another one l've noticed is that applying the offset modifier after the transition modifier makes some animation glitches, so we can apply it at the end of the toast view.
					/// That's why we also moved the .visualEffect modifier to after the gesture modifier.
						// .transition(.asymmetric(insertion: .offset(y: 100), removal: .move(edge: .leading)))
						// .offset(x: toast.offsetX)
						.gesture(
							DragGesture()
								.onChanged { value in
									let xOffset = value.translation.width < 0 ? value.translation.width : 0
									toast.offsetX = xOffset
								}
								.onEnded { value in
									let xOffset = value.translation.width + (value.velocity.width / 2)
									if -xOffset > 200 {
										// Remove toast:
										/// Since the extension is a Binding<> one, make sure to use `$` symbol to access it.
										/// As you can see, there are two problems we need to address. One is to change it's removal transition to a move-based one, and the second is that when the toast is being removed, it's being pushed back to the stack. To solve this, we can use z-index to increase its value when it's being removed.
										$toasts.delete(toast.id)
									} else {
										// Reset toast back to its initial position
										/// Wrap this with the "withAnimation" modifier to have animations when it's resetting to its initial position.
										toast.offsetX = 0
									}
								}
						)
					/// without capturing the isExpanded we get this error:
					/// Main actor-isolated property 'isExpanded' can not be referenced from a Sendable closure; this is an error in the Swift 6 language mode
					/// I think that's because isExpanded is mutable
						.visualEffect { [isExpanded] content, proxy in
							content
								.scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
								.offset(y: isExpanded ? 0 : offsetY(index))
						}
						.zIndex(toast.isDeleting ? 1000 : 0)
					/// So this will make the toast view occupy the full available width, making the transition removal work fine.
						.frame(maxWidth: .infinity)
						.transition(.asymmetric(insertion: .offset(y: 100), removal: .move(edge: .leading)))
				}
			}
			.onTapGesture {
				isExpanded.toggle()
			}
			.padding(.bottom, 15)
		}
		.animation(.bouncy, value: isExpanded)
		.onChange(of: toasts.isEmpty) { oldValue, newValue in
			if newValue {
				isExpanded = false
			}
		}
	}
	
	nonisolated func offsetY(_ index: Int) -> CGFloat {
		/// just want to show only two extra cards, that's why I limited the value to 30. If you want more cards to be visible, then adjust this value as per your needs.
		let offset = min(CGFloat(index) * 15, 30)
		return -offset
	}
	
	nonisolated func scale(_ index: Int) -> CGFloat {
		let scale = min(CGFloat(index) * 0.1, 1)
		return 1 - scale
	}
}

/// This little extension will be useful to remove toasts based on their ID, and since I'm making changes to the binding value rather than the struct, the animation will be still active.
/// (If you make changes to struct, then there will be no animations present.
extension Binding<[InToast]> {
	func delete(_ id: String) {
		if let toast = first(where: { $0.id == id }) {
			toast.wrappedValue.isDeleting = true
		}
		withAnimation(.bouncy) {
			self.wrappedValue.removeAll(where: { $0.id == id })
		}
	}
}

#Preview {
	InteractiveToastsContentView()
}
