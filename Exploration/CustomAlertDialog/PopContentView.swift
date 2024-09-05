//
//  PopContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 05/09/2024.
//  Source - https://youtu.be/Q5aiAtm5rBI?si=7HjACbVCnqDH84hm

import SwiftUI

struct PopContentView: View {
	@State private var showPopup: Bool = false
	@State private var showAlert: Bool = false
	@State private var isWrongPassword: Bool = false
	@State private var isTryingAgain: Bool = false
	
	var body: some View {
		NavigationStack {
			Button("Unlock File") {
				showPopup.toggle()
			}
			.navigationTitle("Documents")
		}
		.popView(isPresented: $showPopup) {
			showAlert = isWrongPassword
			isWrongPassword = false
		} content: {
			// Button("Close") {
				/// Because I'm making this full screen cover work without it's default animations, closing the view with the dismiss) environment will activate the full screen cover's animation, so avoid using dismiss) environment.
				// showPopup = false
			// }
			CustomAlertWithTextField(show: $showPopup) { password in
				isWrongPassword = password != "Tobi"
			}
		}
		.popView(isPresented: $showAlert) {
			showPopup = isTryingAgain
			isTryingAgain = false
		} content: {
			CustomAlert(show: $showAlert) {
				isTryingAgain = true
			}
		}

	}
}

// Now let's create a custom alert with a textfield.
fileprivate struct CustomAlertWithTextField: View {
	@Binding var show: Bool
	var onUnlock: (String) -> Void
	@State private var password: String = ""
	
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "person.badge.key.fill")
				.font(.title)
				.foregroundStyle(.white)
				.frame(width: 65, height: 65)
				.background {
					Circle()
						.fill(.blue.gradient)
						.background {
							Circle()
								.fill(.background)
								.padding(-5)
						}
				}
			Text("Locked File")
				.fontWeight(.semibold)
			Text("This file has been locked by the user, please enter the password to continue")
				.multilineTextAlignment(.center)
				.font(.caption)
				.foregroundStyle(.secondary)
				.padding(.top, 5)
			SecureField("Password", text: $password)
				.padding(.vertical, 10)
				.padding(.horizontal, 15)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.fill(.bar)
				}
				.padding(.vertical, 10)
			
			HStack(spacing: 10) {
				Button {
					show = false
				} label: {
					Text("Cancel")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 10)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 25)
								.fill(.red.gradient)
						}
				}
				
				Button {
					show = false
					onUnlock(password)
				} label: {
					Text("Unlock")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 10)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 25)
								.fill(.blue.gradient)
						}
				}
			}
		}
		.frame(width: 250)
		.padding([.horizontal, .bottom], 25)
		.background {
			RoundedRectangle(cornerRadius: 25)
				.fill(.background)
				.padding(.top, 25)
		}
	}
}

/// Now let's show how to synchronise multiple alerts.
fileprivate struct CustomAlert: View {
	@Binding var show: Bool
	var onTryAgain: () -> Void
	
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "lock.trianglebadge.exclamationmark.fill")
				.font(.title)
				.foregroundStyle(.white)
				.frame(width: 65, height: 65)
				.background {
					Circle()
						.fill(.red.gradient)
						.background {
							Circle()
								.fill(.background)
								.padding(-5)
						}
				}
			Text("Wrong Password")
				.fontWeight(.semibold)
			
			Text("Please enter the correct password to unlock the file.")
				.multilineTextAlignment(.center)
				.font(.caption)
				.foregroundStyle(.secondary)
				.padding(.top, 5)
			
			HStack(spacing: 10) {
				Button {
					show = false
				} label: {
					Text("Cancel")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 10)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 25)
								.fill(.red.gradient)
						}
				}
				
				Button {
					show = false
					onTryAgain()
				} label: {
					Text("Try Again")
						.foregroundStyle(.white)
						.fontWeight(.semibold)
						.padding(.vertical, 10)
						.padding(.horizontal, 25)
						.background {
							RoundedRectangle(cornerRadius: 25)
								.fill(.blue.gradient)
						}
				}
			}
		}
		.frame(width: 250)
		.padding([.horizontal, .bottom], 25)
		.background {
			RoundedRectangle(cornerRadius: 25)
				.fill(.background)
				.padding(.top, 25)
		}
	}
}

#Preview {
	PopContentView()
}
