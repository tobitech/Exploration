import SwiftUI
import PhotosUI

struct PickerInteractionProperties {
	var storedKeyboardHeight: CGFloat = 0.0
	var dragOffset: CGFloat = 0
	var showPhotoPicker: Bool = false
	
	var keyboardHeight: CGFloat {
		/// Since there is no way to read the keyboard height without showing one, I'm going to set an average keyboard height as 300,
		/// so if a user clicks photo picker straight away without pressing the text field, it will use this value and when the keyboard gets visible the value gets updated.
		storedKeyboardHeight == 0 ? 300 : storedKeyboardHeight
	}
	
	var safeArea: UIEdgeInsets {
		if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
			return safeArea
		}
		return .zero
	}

	var screenSize: CGSize {
		if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
			return size
		}
		return .zero
	}
	
	var animation: Animation {
		// Replace with your desired animation (NOTE: Don't exceed duration of 0.3 as it's the maximum time, keyboard animation will occur)
		.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0)
	}
}


/// Let's update and solve the following issues:
/// 1. When using a navigation "large" title, the layout calculation might be slightly off. To fix this, consider switching to inline, inlineLarge, or completely hiding the navigation bar and creating a custom one.
/// 2. Let's add an animation that transforms the "plus" symbol into a "X" symbol when the photo picker is active.
/// 3. We need to resolve the issue where the bottom bar briefly hides when switching from the photo picker to the keyboard.
struct MessageView: View {
	// View Properties
	@State private var properties: PickerInteractionProperties = .init()
	@State private var messageText: String = ""
	@State private var selectedPhoto: PhotosPickerItem?
	@FocusState private var isKeyboardActive: Bool
	
	var body: some View {
		ScrollView(.vertical) {
			
		}
		.scrollDismissesKeyboard(.interactively)
		.safeAreaInset(edge: .bottom, spacing: 10) {
			BottomBar()
		}
		/// By default, SwiftUl pushes the SafeAreaBottom view to the top of the keyboard view. However, when we merge it with a Photo Picker Sheet, it bounces back and forth when the sheet or keyboard is switching.
		/// To avoid this, I'll ignore the default keyboard avoidance and implement a custom one by reading the keyboard height and using the same height as the sheet's starting detent to match them!
		.ignoresSafeArea(.keyboard, edges: .all)
			/// If your text field is a single-line text field, it already includes a return button, so there's no issue in that case. However, in most situations, these kinds of Uls use a multi-line text field, like the one shown here. In such scenarios, we can use the scrollDismissKeyboard modifier to allow users to dismiss the keyboard interactively by swiping down.
			/// With this, we've successfully created an interaction similar to the one found in the iMessage app, except for the interactive bottombar + keyboard dismissal behaviour.
			/// As of now, there is no way to read the scroll dismissal behaviour offset updates, but on iOS 26+, the view gets updated when this does happen, so we can use the "onGeometryReader" modifier to calculate the offset and apply it to the bottom bar, but it only works if the view follows these criteria,
			/// 1. It should not have the ignoreSafeArea modifier applied.
			/// 2. It must not have padding, scale, frame, or any other similar modifiers applied.
		.background {
			if #available(iOS 26, *) {
				Rectangle()
					.fill(.clear)
					.onGeometryChange(for: CGFloat.self) {
						$0.frame(in: .global).maxY
					} action: { newValue in
						guard properties.storedKeyboardHeight != 0 else { return }
						let height = max(properties.screenSize.height - newValue - properties.safeArea.bottom, 0)
						properties.dragOffset = properties.storedKeyboardHeight - height
					}
					.ignoresSafeArea(.container, edges: .all)
			}
		}
		.navigationTitle("Codable")
	}
	
	// Bottom Bar
	@ViewBuilder
	func BottomBar() -> some View {
		HStack(alignment: .bottom, spacing: 8) {
			Button {
				properties.showPhotoPicker.toggle()
			} label: {
				Image(systemName: "plus")
					.fontWeight(.medium)
					.foregroundStyle(Color.black)
					.frame(width: 40, height: 40)
					.background(.ultraThinMaterial, in: .circle)
					.contentShape(.circle)
			}

			TextField("Message...", text: $messageText, axis: .vertical)
				.lineLimit(6)
				.padding(.horizontal)
				.padding(.vertical, 10)
				.background(.ultraThinMaterial)
				.clipShape(.rect(cornerRadius: 30))
				.focused($isKeyboardActive)
		}
		.padding(.horizontal)
		.padding(.bottom, 10)
		.geometryGroup()
		.padding(.bottom, animatedKeyboardHeight)
		.offset(y: isKeyboardActive ? properties.dragOffset : 0)
		.animation(properties.animation, value: animatedKeyboardHeight)
		// Extracting keyboard height
		.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { info in
			if let frame = info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
				let height = frame.cgRectValue.height
				if properties.storedKeyboardHeight == 0 {
					/// Saving keyboard height
					properties.storedKeyboardHeight = max(height - properties.safeArea.bottom, 0)
				}
			}
		}
		// Photos Picker
		.sheet(isPresented: $properties.showPhotoPicker) {
			PhotosPicker("", selection: $selectedPhoto)
				.photosPickerStyle(.inline)
				// Disable even more according to your needs
				.photosPickerDisabledCapabilities([.stagingArea, .sensitivityAnalysisIntervention])
				.presentationDetents([.height(properties.keyboardHeight), .large])
				.presentationBackgroundInteraction(.enabled(upThrough: .height(properties.keyboardHeight)))
		}
		// OnChange callbacks
		.onChange(of: properties.showPhotoPicker) { oldValue, newValue in
			if newValue {
				isKeyboardActive = false
			}
		}
		.onChange(of: isKeyboardActive) { oldValue, newValue in
			if newValue {
				properties.showPhotoPicker = false
			}
		}
	}
	
	var animatedKeyboardHeight: CGFloat {
		(properties.showPhotoPicker || isKeyboardActive) ? properties.keyboardHeight : 0
	}
}

#Preview {
	NavigationStack {
		MessageView()
	}
}
