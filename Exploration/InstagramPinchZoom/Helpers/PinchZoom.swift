//
//  PinchZoom.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 29/03/2024.
//

import SwiftUI

extension View {
	@ViewBuilder
	func pinchZoom(_ dimsBackground: Bool = true) -> some View {
		PinchZoomHelper(dimsBackground: dimsBackground) {
			self
		}
	}
}

// Zoom Container View
// Where the zooming view will be displayed and zoomed
struct ZoomContainer<Content: View>: View {
	private var containerData = ZoomContainerData()
	var content: Content
	
	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}
	
	var body: some View {
		GeometryReader { _ in
			content
				.environment(containerData)
			
			ZStack(alignment: .topLeading) {
				if let view = containerData.zoomingView {
					Group {
						if containerData.dimsBackground {
							Rectangle()
								.fill(.black.opacity(0.25))
								.opacity(containerData.zoom - 1)
						}
						view
							.scaleEffect(containerData.zoom, anchor: containerData.zoomAnchor)
							.offset(containerData.dragOffset)
						// View Position
							.offset(x: containerData.viewRect.minX, y: containerData.viewRect.minY)
					}
				}
			}
			.ignoresSafeArea()
		}
	}
}

// Observable Class to share data between Container and its views inside it.
// With the help of this Observable class, we can transfer data from the child views (which manage gestures) to the container view, which manages offset updating and zoom.
@Observable
fileprivate class ZoomContainerData {
	var zoomingView: AnyView?
	var viewRect: CGRect = .zero
	var dimsBackground: Bool = false
	// View Properties
	var zoom: CGFloat = 1
	var zoomAnchor: UnitPoint = .center
	var dragOffset: CGSize = .zero
	/// Sometimes, the user may trigger another event before the animation is completely finished. To avoid that, we can introduce a property to identify whether the animation is completely finished or not.
	var isResetting: Bool = false
}


// Helper View
fileprivate struct PinchZoomHelper<Content: View>: View {
	var dimsBackground: Bool
	@ViewBuilder var content: Content
	// View Properties
	@Environment(ZoomContainerData.self) private var containerData
	@State private var config: Config = .init()
	var body: some View {
		content
			.opacity(config.hidesSourceView ? 0 : 1)
			.overlay(GestureOverlay(config: $config))
			.overlay {
				GeometryReader {
					let rect = $0.frame(in: .global)
					Color.clear
						.onChange(of: config.isGestureActive) { oldValue, newValue in
							if newValue {
								guard !containerData.isResetting else { return }
								// Showing View on Zoom Container
								containerData.viewRect = rect
								containerData.zoomAnchor = config.zoomAnchor
								containerData.dimsBackground = dimsBackground
								containerData.zoomingView = .init(erasing: content)
								// Hiding source view
								config.hidesSourceView = true
							} else {
								// Resetting to its initial position with animation.
								containerData.isResetting = true
								withAnimation(.snappy(duration: 0.3, extraBounce: 0), completionCriteria: .logicallyComplete) {
									containerData.dragOffset = .zero
									containerData.zoom = 1
								} completion: {
									// Resetting config
									config = .init()
									// Removing View from container
									containerData.zoomingView = nil
									containerData.isResetting = false
								}
							}
						}
						.onChange(of: config) { oldValue, newValue in
							if config.isGestureActive && !containerData.isResetting {
								// Updating View's position and scale in zoom container
								containerData.zoom = config.zoom
								containerData.dragOffset = config.dragOffset
							}
						}
				}
			}
	}
}

// UIKit Gestures Overlay
/// As of now, Swiftul doesn't have a way to use two-finger drag gestures, Thus, I'm going to use UlKit gestures to make it possible to zoom and pan simultaneously.
fileprivate struct GestureOverlay: UIViewRepresentable {
	@Binding var config: Config
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(config: $config)
	}
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: .zero)
		view.backgroundColor = .clear
		
		// Pan Gesture
		let panGesture = UIPanGestureRecognizer()
		panGesture.name = "PINCHPANGESTURE"
		panGesture.minimumNumberOfTouches = 2
		panGesture.addTarget(context.coordinator, action: #selector(Coordinator.panGesture(gesture:)))
		panGesture.delegate = context.coordinator
		view.addGestureRecognizer(panGesture)
		
		// Pinch Gesture
		let pinchGesture = UIPinchGestureRecognizer()
		pinchGesture.name = "PINCHZOOMGESTURE"
		pinchGesture.addTarget(context.coordinator, action: #selector(Coordinator.pinchGesture(gesture:)))
		pinchGesture.delegate = context.coordinator
		view.addGestureRecognizer(pinchGesture)
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
	
	class Coordinator: NSObject, UIGestureRecognizerDelegate {
		@Binding var config: Config
		
		init(config: Binding<Config>) {
			self._config = config
		}
		
		@objc func panGesture(gesture: UIPanGestureRecognizer) {
			if gesture.state == .began || gesture.state == .changed {
				let translation = gesture.translation(in: gesture.view)
				config.dragOffset = .init(width: translation.x, height: translation.y)
				config.isGestureActive = true
			} else {
				/// We won't reset the zoom and offset values here, Instead, we'll update the gesture state, and in the SwiftUl View, I'll reset the zoom and offset values using animations.The same follows for PinchGesture.
				config.isGestureActive = false
			}
		}
		
		@objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
			if gesture.state == .began {
				let location = gesture.location(in: gesture.view)
				if let bounds = gesture.view?.bounds {
					/// We can pinpoint the anchor point where the touch began to pinch and zoom the view from there.
					config.zoomAnchor = .init(x: location.x / bounds.width, y: location.y / bounds.height)
				}
			}
			
			if gesture.state == .began || gesture.state == .changed {
				let scale = max(gesture.scale, 1) // limiting the scale minimum value to 1 but you can change as per your needs.
				config.zoom = scale
				config.isGestureActive = true
			} else {
				config.isGestureActive = false
			}
		}
		
		func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
			if gestureRecognizer.name == "PINCHPANGESTURE" && otherGestureRecognizer.name == "PINCHZOOMGESTURE" {
				return true
			}
			return false
		}
	}
}

// Config
fileprivate struct Config: Equatable {
	var isGestureActive: Bool = false
	var zoom: CGFloat = 1
	var zoomAnchor: UnitPoint = .center
	var dragOffset: CGSize = .zero
	var hidesSourceView: Bool = false
}

#Preview {
	IGPinchZoomContentView()
}
