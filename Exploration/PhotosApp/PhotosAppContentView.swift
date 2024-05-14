//
//  PhotosAppContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 11/05/2024.
//  Source - https://youtu.be/ktaGsPwGZpA?si=RfyBlwRc5r6kcNoD

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
				.opacity(coordinator.animateView ? 1 : 0)
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
