import SwiftUI

struct ExpandableMusicPlayer: View {
	@Binding var show: Bool
	
	// View Properties
	@State private var gradient: AnyGradient = Color.clear.gradient
	@State private var expandPlayer: Bool = false
	@State private var offsetY: CGFloat = 0.0
	@State private var mainWindow: UIWindow?
	@State private var windowProgress: CGFloat = 0.0
	// Let's make it better by adding matchedGeometry effect to the artwork image view.
	@Namespace private var animation
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			
			ZStack(alignment: .top) {
				// Background
				ZStack {
					Rectangle()
						.fill(.ultraThinMaterial)
					
//					Rectangle()
//						.fill(.linearGradient(colors: [.artwork1, .artwork2, .artwork3], startPoint: .top, endPoint: .bottom))
//						.opacity(expandPlayer ? 1 : 0)
					Rectangle()
						.fill(gradient)
						.opacity(expandPlayer ? 1 : 0)
				}
				/// you can customize the corner radius based on the device.
				.clipShape(.rect(cornerRadius: expandPlayer ? 45 : 15))
				.frame(height: expandPlayer ? nil : 55)
				// Shadows
				.shadow(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5)
				.shadow(color: .primary.opacity(0.05), radius: 5, x: -5, y: -5)
				
				// Mini Player
				MiniPlayer()
					.opacity(expandPlayer ? 0 : 1)
				
				ExpandedPlayer(size, safeArea)
					.opacity(expandPlayer ? 1 : 0)
			}
			/// Limiting the height, based on the `expandPlayer` state value.
			.frame(height: expandPlayer ? nil : 55, alignment: .top)
			.frame(maxHeight: .infinity, alignment: .bottom)
			.padding(.bottom, expandPlayer ? 0 : safeArea.bottom + 55)
			.padding(.horizontal, expandPlayer ? 0 : 15)
			.offset(y: offsetY)
			.gesture(
				PanGesture(
					onChange: { value in
						guard expandPlayer else { return }
						let translation = max(value.translation.height, 0)
						offsetY = translation
						windowProgress = max(min(translation / size.height, 1), 0) * 0.1
						
						resizeWindow(0.1 - windowProgress)
					},
					onEnd: { value in
						guard expandPlayer else { return }
						let translation = max(value.translation.height, 0)
						let velocity = value.velocity.height / 5
						withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
							if (translation + velocity) > (size.height * 0.3) {
								// Closing View
								expandPlayer = false
								// Resetting Window To Identity With Animation
								resetWindowWithAnimation()
							} else {
								// Reset Window To 0.1 with Animation
								UIView.animate(withDuration: 0.3) {
									resizeWindow(0.1)
								}
							}
							
							offsetY = 0
						}
					}
				)
			)
			.ignoresSafeArea()
			
//			Slider(value: $windowProgress, in: 0...0.1)
//				.padding(15)
//				.onChange(of: windowProgress) { oldValue, newValue in
//					resizeWindow(newValue)
//				}
		}
		.onAppear {
			if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow, mainWindow == nil {
				mainWindow = window
			}
			gradient = Color(UIImage(named: "artwork2")?.prominentColor ?? .clear).gradient
		}
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
			if expandPlayer {
				mainWindow?.subviews.first?.transform = .identity
			}
		}
	}
	
	// Mini Player
	@ViewBuilder
	func MiniPlayer() -> some View {
		HStack(spacing: 12) {
			ZStack {
				if !expandPlayer {
					Image(.artwork2)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipShape(.rect(cornerRadius: 10))
						.matchedGeometryEffect(id: "Artwork", in: animation)
				}
			}
			.frame(width: 45, height: 45)

			Text("Calm Down")
			
			Spacer(minLength: 0)
			
			Group {
				Button("", systemImage: "play.fill") {
					
				}
				
				Button("", systemImage: "forward.fill") {
					
				}
			}
			.font(.title3)
			.foregroundStyle(.primary)
		}
		.padding(.horizontal, 10)
		.frame(height: 55)
		.contentShape(.rect)
		.onTapGesture {
			withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
				expandPlayer = true
			}
			
			// Resizing window when opening the player
			UIView.animate(withDuration: 0.3) {
				resizeWindow(0.1)
			}
		}
	}
	
	@ViewBuilder
	func ExpandedPlayer(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
		VStack(spacing: 12) {
			Capsule()
				.fill(.white.secondary)
				.frame(width: 35, height: 5)
				.offset(y: -10)
			
			// Sample Player View
			HStack(spacing: 12) {
				ZStack {
					if expandPlayer {
						Image(.artwork2)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.clipShape(.rect(cornerRadius: 10))
							.matchedGeometryEffect(id: "Artwork", in: animation)
							.transition(.offset(y: 1))
					}
				}
				.frame(width: 80, height: 80)
				
				VStack(alignment: .leading, spacing: 2) {
					Text("Calm Down")
						.fontWeight(.semibold)
						.foregroundStyle(.white)
					Text("Rema, Selena Gomez")
						.font(.caption2)
						.foregroundStyle(.white.secondary)
				}
				Spacer(minLength: 0)
				
				HStack(spacing: 0) {
					Button("", systemImage: "star.circle.fill") {
						
					}
					
					Button("", systemImage: "ellipsis.circle.fill") {
						
					}
				}
				.foregroundStyle(.white, .white.tertiary)
				.font(.title2)
			}
		}
		.padding(15)
		.padding(.top, safeArea.top)
	}
	
	func resizeWindow(_ progress: CGFloat) {
		if let mainWindow = mainWindow?.subviews.first {
			/// let's set the scaling anchor to bottom, and set some corner radius while scaling
			let offsetY = (mainWindow.frame.height * progress) / 2
			// Your custom corner radius
			mainWindow.layer.cornerRadius = (progress / 0.1) * 30
			mainWindow.layer.masksToBounds = true
			
			/// The first subview of the key window is our SwiftUl app content, and all the other subviews are sheets/fullscreencovers/inspector, etc.
			/// And since the max window progress value is 0.1 and the maximum scaling that will be applied will be 0.9, let's see how it looks by creating a slider to stimulate the effect.
			mainWindow.transform = .identity
				.scaledBy(x: 1 - progress, y: 1 - progress)
				.translatedBy(x: 0, y: offsetY)
		}
	}
	
	func resetWindowWithAnimation() {
		if let mainWindow = mainWindow?.subviews.first {
			UIView.animate(withDuration: 0.3) {
				mainWindow.layer.cornerRadius = 0.0
				mainWindow.transform = .identity
			}
		}
	}
}

#Preview {
	UniRootView {
		MiniPlayerHomeView()
	}
}
