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

#Preview {
	ImageSliderContentView()
}
