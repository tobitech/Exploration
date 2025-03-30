//
//  AnimatedDialogContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 30/03/2025.
//  Source - https://youtu.be/fgmsbYgcc3o?si=u9nFJi0YJyH66KXS

import SwiftUI

struct AnimatedDialogContentView: View {
	@State private var config: DrawerConfig = .init()

	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				DrawerButton(
					title: "Continue",
					config: $config
				)
			}
			.padding()
			.navigationTitle("Alert Drawer")
		}
		.alertDrawer(
			config: $config,
			primaryTitle: "Continue",
			secondaryTitle: "Cancel",
			onPrimaryClick: {
				return false
			},
			onSecondaryClick: {
				return true
			},
			content: {
				// Dummy Content
				VStack(alignment: .leading, spacing: 15) {
					Image(systemName: "exclamationmark.circle")
						.font(.largeTitle)
						.foregroundStyle(.red)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Text("Are you sure?")
						.font(.title2.bold())
					
					Text("You haven't backed up your wallet yet.\nIf you remove it, you could lose access forever. We suggest tapping Cancel and backing up your wallet first with a valid recovery method.")
						.foregroundStyle(.secondary)
						.fixedSize(horizontal: false, vertical: true)
						.frame(width: 300)
				}
			}
		)
	}
}

#Preview {
	AnimatedDialogContentView()
}
