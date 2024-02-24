//
//  Toast.swift
//  CustomToasts
//
//  Created by Tobi Omotayo on 16/02/2024.
//

import SwiftUI

// Root View for Creating Overlay Window
struct RootView<Content: View>: View {
	@ViewBuilder var content: Content
	
	// View Properties
	@State private var overlayWindow: UIWindow?
	
	var body: some View {
		content
			.onAppear {
				if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
					let window = PassthroughWindow(windowScene: windowScene)
					window.backgroundColor = .clear
					// View Controller
					let rootController = UIHostingController(rootView: ToastGroup())
					rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
					rootController.view.backgroundColor = .clear
					window.rootViewController = rootController
					window.isHidden = false
					window.isUserInteractionEnabled = true
					// You can use this `tag` value to extract the overlay window from the window scene Wherever you want.
					window.tag = 1009
					overlayWindow = window
				}
			}
	}
}

// In order to make the root view controller interactable, we need to convert the overlay window into a pass-through window, which passes all the interactions to the root view controller.
fileprivate class PassthroughWindow: UIWindow {
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard let view = super.hitTest(point, with: event) else { return nil }
		return rootViewController?.view == view ? nil : view
	}
}

@Observable
class Toast {
	// Since the class conforms to the Observable protocol, we can use this singleton object as a state object to receive Ul updates on the overlay window root controller.
	static let shared = Toast()
	fileprivate var toasts: [ToastItem] = []
	
	func present(
		title: String,
		symbol: String?,
		tint: Color = .primary,
		isUserInteractionEnabled: Bool = false,
		timing: ToastTime = .medium
	) {
		withAnimation(.snappy) {
			self.toasts.append(
				ToastItem(
					title: title,
					symbol: symbol,
					tint: tint,
					isUserInteractionEnabled: isUserInteractionEnabled,
					timing: timing
				)
			)
		}
	}
}

struct ToastItem: Identifiable {
	var id: UUID = .init()
	var title: String
	var symbol: String?
	var tint: Color
	var isUserInteractionEnabled: Bool
	// Timing
	var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
	case short = 1.0
	case medium = 2.0
	case long = 3.5
}

fileprivate struct ToastGroup: View {
	var model = Toast.shared
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			
			ZStack {
				ForEach(self.model.toasts) { toast in
					ToastView(size: size, item: toast)
						.scaleEffect(scale(toast))
						.offset(y: offsetY(toast))
					// As you can notice, by using the transition modifier to animate in and out, the toast is being moved all the way down in ZStack when it's removed. We can resolve this issue with the help of the ZIndex modifier.
						.zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
				}
			}
			.padding(.bottom, safeArea.top == .zero ? 15 : 10)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
		}
	}
	
	func offsetY(_ item: ToastItem) -> CGFloat {
		// The offset of the previous toast is moved by 10 up when a new toast is added. This movement can only be added for a maximum of two toasts, after that, the offset of each subsequent toast is set to a maximum of 20.
		let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
		let totalCount = CGFloat(model.toasts.count) - 1
		return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
	}
	
	func scale(_ item: ToastItem) -> CGFloat {
		let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
		let totalCount = CGFloat(model.toasts.count) - 1
		return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
	}
}

struct ToastView: View {
	var size: CGSize
	var item: ToastItem
	// View Properties
	@State private var delayTask: DispatchWorkItem?
	
	var body: some View {
		HStack(spacing: 0) {
			if let symbol = item.symbol {
				Image(systemName: symbol)
					.font(.title3)
					.padding(.trailing, 10)
			}
			Text(item.title)
				.lineLimit(1)
		}
		.foregroundStyle(.tint)
		.padding(.horizontal, 15)
		.padding(.vertical, 8)
		.background(
			.background
				.shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
				.shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
			in: .capsule
		)
		.contentShape(.capsule)
		.gesture(
			DragGesture(minimumDistance: 0)
				.onEnded({ value in
					guard item.isUserInteractionEnabled else { return }
					let endY = value.translation.height
					let velocityY = value.velocity.height
					if (endY + velocityY) > 100 {
						// Removing toast
						removeToast()
					}
				})
		)
		.onAppear {
			guard delayTask == nil else { return }
			delayTask = .init(block: {
				removeToast()
			})
			
			if let delayTask {
				DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
			}
		}
		// Limiting size
		.frame(maxWidth: size.width * 0.7)
		.transition(.offset(y: 150))
	}
	
	private func removeToast() {
		// As you can notice, when I dismiss the toast by swiping it down, it takes a little delay to push the next one up. This is happening because we used state variables to remove the toast from the screen, and when the animation completes, we remove the item from the array. The time delay taken to complete the state change animation is the reason for this delay. We can solve this by simply removing all the state variables to animate in and out and simply replacing them with SwiftUI's default transition.
//		guard !animateOut else { return }
//		withAnimation(.snappy, completionCriteria: .logicallyComplete) {
//			animateOut = true
//		} completion: {
//			removeToasItem()
//		}
		if let delayTask {
			delayTask.cancel()
		}
		print("Hello")
		withAnimation(.snappy) {
			Toast.shared.toasts.removeAll(where: { $0.id == item.id })
		}
	}
}

#Preview {
	RootView {
		CustomToastsContentView()
	}
}
