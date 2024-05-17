//
//  PhotosAppContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 11/05/2024.
//  Source - https://youtu.be/ktaGsPwGZpA?si=RfyBlwRc5r6kcNoD

// Useful comment from the video
/// Very cool! Only a couple missing touches from the actual Photos app people may want to try adding - scaling the image when swiping off screen, allowing swiping from anywhere in the image (not just the leading edge, which must work simultaneously with the ScrollView swipe gesture), hiding the navigation and bottom bars when tapping on the image (and re-appearing when tapping again), and showing an image details view when swiping up on the image. Some of this is pretty trivial to implement, thanks to how well documented your process is!

import SwiftUI

struct PhotosAppContentView: View {
	var coordinator: PhotoUICoordinator = .init()
	
	var body: some View {
		NavigationStack {
			PhotosAppHomeView()
				.environment(coordinator)
			/// So, when a detail view appears, indicating that the selected item is not nil, I will disable home view interactions until the detail view is visible.
				.allowsHitTesting(coordinator.selectedItem == nil)
		}
		/// We use this to hide/cover the home view when detail view is shown.
		.overlay {
			Rectangle()
				.fill(.background)
				.ignoresSafeArea()
				.opacity(coordinator.animateView ? 1 - coordinator.dragProgress : 0)
		}
		.overlay {
			if coordinator.selectedItem != nil {
				PhotosDetailView()
					.environment(coordinator)
				/// The detail view interactions are disabled until the detail view is visible.
					.allowsHitTesting(coordinator.showDetailView)
			}
		}
		/// To animate the layer, we need both the source and destination anchors (Frame to animate from source to destination, which can be obtained through Anchor Preferences. Let's attach the source and destination anchors at the appropriate places.
		.overlayPreferenceValue(HeroKey.self) { value in
			if let selectedItem = coordinator.selectedItem,
				 let sAnchor = value[selectedItem.id + "SOURCE"],
				 let dAnchor = value[selectedItem.id + "DEST"] {
				HeroLayer(
					item: selectedItem,
					sAnchor: sAnchor,
					dAnchor: dAnchor
				)
				.environment(coordinator)
			}
		}
	}
}

#Preview {
	PhotosAppContentView()
}
