//
//  ImageSliderContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 22/12/2024.
//  Source - https://youtu.be/BEGgrLxl3I4?si=iHgloqVjAPltXWPa

import SwiftUI

struct ImageSliderContentView: View {
	var body: some View {
		/// NavigationStack is a must as this uses the Zoom transition API
		NavigationStack {
			VStack {
				ImageViewer {
					ForEach(ImageDataModel.sampleImages) { image in
						/// Animations will work even when image is loading
						AsyncImage(url: URL(string: image.link)) { image in
							image
								.resizable()
								// Fit/Fill resize will be done inside the image viewer
						} placeholder: {
							Rectangle()
								.fill(.gray.opacity(0.4))
								.overlay {
									ProgressView()
										.tint(.blue)
										.scaleEffect(0.7)
										.frame(maxWidth: .infinity, maxHeight: .infinity)
								}
						}
						.containerValue(\.activeViewID, image.id)
					}
				} overlay: {
					OverlayView()
				}
//				updates: { isPresented, activeViewID in
//					print(isPresented, activeViewID)
//				}
			}
			.padding()
			.navigationTitle("Image Viewer")
		}
	}
}

// Overlay View
struct OverlayView: View {
	@Environment(\.dismiss) private var dismiss
	var body: some View {
		VStack {
			Button {
				dismiss()
			} label: {
				Image(systemName: "xmark.circle.fill")
					.font(.title)
					.foregroundStyle(.ultraThinMaterial)
					.padding(10)
					.contentShape(.rect)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			
			Spacer(minLength: 0)
		}
		.padding(15)
	}
}

#Preview {
	ImageSliderContentView()
}
