//
//  ZoomTransitionsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/09/2024.
//  Source - https://youtu.be/malwmE5fDHw?si=ytKKlsVmqASs46ez

import SwiftUI

/// Creating a Zoom transition is very simple.
/// First, we need to create a namespace and
/// then use it in the new matchedTransitionSource Modifier.
struct ZoomTransitionsContentView: View {
	var sharedModel = SharedModel()
	@Namespace private var animation
	var body: some View {
		@Bindable var bindings = sharedModel
		GeometryReader {
			let screenSize: CGSize = $0.size
			NavigationStack {
				VStack(spacing: 0) {
					// Header View
					HeaderView()
					
					ScrollView(.vertical) {
						LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
							ForEach($bindings.videos) { $video in
								// Card View
								NavigationLink(value: video) {
									ZoomCardView(screenSize: screenSize, video: $video)
										.environment(sharedModel)
										.frame(height: screenSize.height * 0.4)
										.matchedTransitionSource(id: video.id, in: animation) { configuration in
											// You can customise the source view configuration as per your needs
											configuration.background(.clear)
												.clipShape(.rect(cornerRadius: 15))
										}
								}
								.buttonStyle(CustomButtonStyle())
							}
						}
						.padding(15)
					}
				}
				.navigationDestination(for: VideoModel.self) { video in
					VideoDetailView(video: video, animation: animation)
						.environment(sharedModel)
						.toolbarVisibility(.hidden, for: .navigationBar)
				}
			}
		}
	}
	
	@ViewBuilder
	func HeaderView() -> some View {
		HStack {
			Button {
			} label: {
				Image(systemName: "magnifyingglass")
					.font(.title3)
			}
			Spacer(minLength: 0)
			Button {
			} label: {
				Image(systemName: "person.fill")
					.font(.title3)
			}
		}
		.overlay {
			Text("Stories")
				.font(.title3.bold())
		}
		.foregroundStyle(.primary)
		.padding(15)
		.background(.ultraThinMaterial)
	}
}

struct ZoomCardView: View {
	var screenSize: CGSize
	@Binding var video: VideoModel
	@Environment(SharedModel.self) private var sharedModel
	var body: some View {
		GeometryReader {
			let size = $0.size
			if let thumbnail = video.thumbnail {
				Image(uiImage: thumbnail)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipShape(.rect(cornerRadius: 15))
			} else {
				RoundedRectangle(cornerRadius: 15)
					.fill(.fill)
					.task(priority: .high) {
						/// If we utilise the card view size, the thumbnail max resolution will be the same as the card size, but this image will be used for zoom transitions in the detail view. Thus, if we utilise these sizes, the image will be pixelated in the detail view, and because the detail view will extend to its full screen size, creating thumbnails for the screen size will be appropriate.
						await sharedModel.generateThumbnail(for: $video, size: screenSize)
					}
			}
		}
	}
}

/// NavigationLink is a form of button, but I don't want this opacity effect when we click the link. Thus, let's create a custom button style to remove this effect.
fileprivate struct CustomButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

#Preview {
	ZoomTransitionsContentView()
}
