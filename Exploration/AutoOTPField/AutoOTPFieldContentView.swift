//
//  AutoOTPFieldContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 19/04/2024.
//  Source - https://youtu.be/E5LdH1MFrqQ?si=siOz070ucCK74RNi

import SwiftUI

struct AutoOTPFieldContentView: View {
	var body: some View {
		if #available(iOS 15, *) {
			/// Why NavigationView?
			/// Because we need a "Done" button above the keyboard, the toolbar can only be added when the view is wrapped up with navigation View.
			NavigationView {
				OTPVerificationView()
					.navigationBarTitleDisplayMode(.inline)
					.navigationBarBackButtonHidden(true)
			}
		} else {
			NavigationStack {
				OTPVerificationView()
					.navigationBarTitleDisplayMode(.inline)
					.toolbar(.hidden, for: .navigationBar)
			}
		}
	}
}

#Preview {
	AutoOTPFieldContentView()
}
