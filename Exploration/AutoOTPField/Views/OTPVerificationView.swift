import SwiftUI

struct OTPVerificationView: View {
	// View Properties
	@State private var otpText: String = ""
	// Keyboard State
	/// Since we're going to hide the text field with the help of @FocusState, we can toggle the keyboard on and off
	@FocusState private var isKeyboardShowing: Bool
	
	var body: some View {
		VStack {
			Text("Verify OTP")
				.font(.largeTitle.bold())
				.frame(maxWidth: .infinity, alignment: .leading)
			
			HStack(spacing: 0) {
				// OTP Text Boxes - Change count based on your needs.
				ForEach(0..<6, id: \.self) { index in
					OTPTextBox(index)
				}
			}
			.background {
				TextField("", text: $otpText.limit(6))
					.keyboardType(.numberPad)
					/// To show the most recent one-time code from messages.
					.textContentType(.oneTimeCode)
					// Hiding it out.
					.frame(width: 1, height: 1)
					.opacity(0.001)
					.blendMode(.screen)
					.focused($isKeyboardShowing)
			}
			.contentShape(Rectangle())
			// Opening Keyboard when tapped.
			/// We created a @FocusState property to toggle the keyboard whenever OTP fields are tapped because the text field no longer responds to the default tap to open the keyboard, because we hid it (by setting width and height to 1).
			.onTapGesture {
				isKeyboardShowing.toggle()
			}
			.padding(.bottom, 20)
			.padding(.top, 10)
			
			Button {
				
			} label: {
				Text("Verify")
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.padding(.vertical, 12)
					.frame(maxWidth: .infinity)
					.background {
						RoundedRectangle(cornerRadius: 6, style: .continuous)
							.fill(.blue)
					}
			}
			.disableWithOpacity(otpText.count < 6)
		}
		.padding(.all)
		.frame(maxHeight: .infinity, alignment: .top)
		.toolbar {
			ToolbarItem(placement: .keyboard) {
				Button("Done") {
					isKeyboardShowing.toggle()
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
		}
	}
	
	// MARK: OTP Text Box
	@ViewBuilder
	func OTPTextBox(_ index: Int) -> some View {
		ZStack {
			// Safe check to avoid crashes while reading the string index
			if otpText.count > index {
				// Finding Char at index
				let startIndex = otpText.startIndex
				let charIndex = otpText.index(startIndex, offsetBy: index)
				let charToString = String(otpText[charIndex])
				Text(charToString)
			} else {
				Text(" ")
			}
		}
		.frame(width: 45, height: 45)
		.background {
			// Highlighting  current active box.
			let status = (isKeyboardShowing && otpText.count == index)
			RoundedRectangle(cornerRadius: 6, style: .continuous)
				.stroke(status ? .black : .gray, lineWidth: status ? 1 : 0.5)
				// Adding Animation
				.animation(.easeInOut(duration: 0.2), value: status)
		}
		.frame(maxWidth: .infinity)
	}
}

#Preview {
	AutoOTPFieldContentView()
}

// MARK: View Extensions
extension View {
	func disableWithOpacity(_ condition: Bool) -> some View {
		self
			.disabled(condition)
			.opacity(condition ? 0.6 : 1)
	}
}

// MARK: Binding<String> Extension
/// Creating an extension for limiting the binding string to some prescribed limit
extension Binding where Value == String {
	func limit(_ length: Int) -> Self {
		if self.wrappedValue.count > length {
			DispatchQueue.main.async {
				self.wrappedValue = String(self.wrappedValue.prefix(length))
			}
		}
		return self
	}
}

