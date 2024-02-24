//
//  LockView.swift
//  BiometricPINLock
//
//  Created by Oluwatobi Omotayo on 18/01/2024.
//

import LocalAuthentication
import SwiftUI

struct LockView<Content: View>: View {
	/// Lock Properties
	var lockType: LockType
	var lockPin: String
	var isEnabled: Bool
	var lockWhenAppGoesBackground: Bool = true
	@ViewBuilder var content: Content
	var forgotPin: () -> Void = {}
	
	/// View Properties
	@State private var pin: String = ""
	@State private var animateField: Bool = false
	@State private var isUnlocked: Bool = false
	@State private var noBiometricAccess: Bool = false
	/// Lock context
	var context = LAContext()
	@Environment(\.scenePhase) private var scenePhase
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			content.frame(width: size.width, height: size.height)
			if self.isEnabled && !self.isUnlocked {
				ZStack {
					Rectangle()
						.fill(.black)
						.ignoresSafeArea()
					if (self.lockType == .both && !self.noBiometricAccess) || self.lockType == .biometric {
						Group {
							if self.noBiometricAccess {
								Text("Enable biometric authentication in Settings to unlock the view.")
									.font(.callout)
									.multilineTextAlignment(.center)
									.padding(50)
							} else {
								/// Biometric / pin unlock
								VStack(spacing: 12) {
									VStack(spacing: 6) {
										Image(systemName: "lock")
											.font(.largeTitle)
										Text("Tap to unlock")
											.font(.caption2)
											.foregroundStyle(.secondary)
									}
									.frame(width: 100, height: 100)
									.background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
									.contentShape(.rect)
									.onTapGesture {
										self.unlockView()
									}
									
									if self.lockType == .both {
										Text("Enter Pin")
											.frame(width: 100, height: 40)
											.background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
											.contentShape(.rect)
											.onTapGesture {
												self.noBiometricAccess = true
											}
									}
								}
							}
						}
					} else {
						// Custom Number pad to type app lock pin.
						NumberPadPinView()
					}
				}
				.environment(\.colorScheme, .dark)
				.transition(.offset(y: size.height + 100))
			}
		}
		.onChange(of: self.isEnabled, initial: true) { oldValue, newValue in
			if newValue {
				self.unlockView()
			}
		}
		/// Locking the app when it goes to background.
		.onChange(of: self.scenePhase) { oldValue, newValue in
			if newValue != .active && self.lockWhenAppGoesBackground {
				self.isUnlocked = false
				self.pin = ""
			}
		}
	}
	
	private func unlockView() {
		/// Checking and unlocking view.
		Task {
			if self.isBiometricAvailable && self.lockType != .number {
				/// Requestion Biometric unlock.
				if let result = try? await self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the view"), result {
					print("Unlocked")
					withAnimation(.snappy, completionCriteria: .logicallyComplete) {
						self.isUnlocked = true
					} completion: {
						self.pin = ""
					}
				}
			}
			
			/// No Biometric permission, lock type must be set as keypad.
			/// Updating biometric status.
			self.noBiometricAccess = !self.isBiometricAvailable
		}
	}
	
	private var isBiometricAvailable: Bool {
		return self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
	}
	
	/// Number Pad Pin View
	@ViewBuilder
	private func NumberPadPinView() -> some View {
		VStack {
			Text("Enter Pin")
				.font(.title.bold())
				.frame(maxWidth: .infinity)
				.overlay(alignment: .leading) {
					/// Back button only for both lock type.
					if self.lockType == .both && self.isBiometricAvailable {
						Button(action: {
							self.pin = ""
							self.noBiometricAccess = false
						}, label: {
							Image(systemName: "arrow.left")
								.font(.title3)
								.contentShape(.rect)
						})
						.tint(.white)
						.padding(.leading)
					}
				}
			
			/// Adding wiggling animation for wrong pin with keyframe animator.
			HStack(spacing: 10) {
				ForEach(0..<4, id: \.self) { index in
					RoundedRectangle(cornerRadius: 10)
						.frame(width: 50, height: 55)
					/// Showing Pin at each box with the help of Index
						.overlay {
							/// Safe check
							if self.pin.count > index {
								let index = self.pin.index(self.pin.startIndex, offsetBy: index)
								let string = String(self.pin[index])
								Text(string)
									.font(.title.bold())
									.foregroundStyle(.black)
							}
						}
				}
			}
			.keyframeAnimator(
				initialValue: CGFloat.zero,
				trigger: self.animateField,
				content: { content, value in
					content
						.offset(x: value)
				},
				keyframes: { _ in
					KeyframeTrack {
						CubicKeyframe(30, duration: 0.07)
						CubicKeyframe(-30, duration: 0.07)
						CubicKeyframe(20, duration: 0.07)
						CubicKeyframe(-20, duration: 0.07)
						CubicKeyframe(0, duration: 0.07)
					}
				}
			)
			.padding(.top, 15)
			.overlay(alignment: .bottomTrailing, content: {
				Button("Forgot Pin?", action: self.forgotPin)
					.foregroundStyle(.white)
					.offset(y: 40)
			})
			.frame(maxHeight: .infinity)
			
			/// Custom Number Pad
			GeometryReader { _ in
				LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
					ForEach(1...9, id: \.self) { number in
						Button(action: {
							/// Adding number to pin
							/// Max limit - 4
							if self.pin.count < 4 {
								self.pin.append("\(number)")
							}
						}, label: {
							Text("\(number)")
								.font(.title)
								.frame(maxWidth: .infinity)
								.padding(.vertical, 20)
								.contentShape(.rect)
						})
						.tint(.white)
					}
					
					/// 0 and back button
					Button(action: {
						if !self.pin.isEmpty {
							self.pin.removeLast()
						}
					}, label: {
						Image(systemName: "delete.backward")
							.font(.title)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 20)
							.contentShape(.rect)
					})
					.tint(.white)
					
					Button(action: {
						if self.pin.count < 4 {
							self.pin.append("0")
						}
					}, label: {
						Text("0")
							.font(.title)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 20)
							.contentShape(.rect)
					})
					.tint(.white)
				})
				.frame(maxHeight: .infinity, alignment: .bottom)
			}
			.onChange(of: self.pin) { oldValue, newValue in
				if newValue.count == 4 {
					/// Validate Pin
					if self.lockPin == self.pin {
						// print("Unlocked")
						withAnimation(.snappy, completionCriteria: .logicallyComplete) {
							self.isUnlocked = true
						} completion: {
							self.pin = ""
							self.noBiometricAccess = !self.isBiometricAvailable
						}
					} else {
						// print("Wrong Pin")
						self.pin = ""
						self.animateField.toggle()
					}
				}
			}
		}
		.padding()
		.environment(\.colorScheme, .dark)
	}
}

enum LockType: String {
	case biometric = "Biometric Auth"
	case number = "Custom Number Lock"
	case both = "First preference will be biometric, and if it's not available, it will go for number lock."
}

#Preview {
	BiometricPINLockContentView()
}
