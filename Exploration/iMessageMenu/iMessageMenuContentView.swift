//
//  iMessageMenuContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 24/05/2025.
//  Source - https://youtu.be/_uz-fez-kcs?si=gBG64jHdGgPxu9Z-

import SwiftUI

struct iMessageMenuContentView: View {
	@State private var config: MenuConfig = MenuConfig(symbolImage: "plus")
	
	var body: some View {
		CustomMenuView(
			config: $config,
			content: {
				// Your Root View
				NavigationStack {
					ScrollView(.vertical) {
						
					}
					.scrollDismissesKeyboard(.interactively)
					.navigationTitle("Messages")
					.safeAreaInset(edge: .bottom) {
						BottomBar()
					}
				}
			},
			actions: {
				// Sample Actions
				MenuAction(symbolImage: "camera", text: "Camera")
				MenuAction(symbolImage: "photo.on.rectangle.angled", text: "Photos")
				MenuAction(symbolImage: "face.smiling", text: "Genmoji")
				MenuAction(symbolImage: "waveform", text: "Audio")
				MenuAction(symbolImage: "apple.logo", text: "App Store")
				MenuAction(symbolImage: "video.badge.waveform", text: "Facetime")
				MenuAction(symbolImage: "rectangle.and.text.magnifyingglass", text: "Images")
				MenuAction(symbolImage: "suit.heart", text: "Digital Touch")
				MenuAction(symbolImage: "location", text: "Location")
				MenuAction(symbolImage: "music.note", text: "Music")
			}
		)
	}
	
	// Custom Bottom Bar
	@ViewBuilder
	func BottomBar() -> some View {
		HStack(spacing: 12) {
			// Custom Menu Source Button
			MenuSourceButton(
				config: $config,
				content: {
					Image(systemName: "plus")
						.font(.title3)
						.frame(width: 35, height: 35)
						.background {
							Circle()
								.fill(.gray.opacity(0.25))
								.background(.background, in: .circle)
						}
				},
				onTap: {
					// Example usage:
					// Can close keyboard if opened, etc.
					print("Tapped")
				}
			)
			
			TextField("Text Message", text: .constant(""))
				.padding(.vertical, 8)
				.padding(.horizontal, 15)
				.background {
					Capsule()
						.stroke(.gray.opacity(0.3), lineWidth: 1.5)
				}
		}
		.padding(.horizontal, 15)
		.padding(.bottom, 10)
	}
}

#Preview {
	iMessageMenuContentView()
}
