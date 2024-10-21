//
//  UniversalOverlayContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 21/10/2024.
//  Source - https://youtu.be/B8JGLwg_yxg?si=WqptiistWtTczD9p

import SwiftUI
import AVKit

struct UniversalOverlayContentView: View {
	@State private var show: Bool = false
	@State private var showSheet: Bool = false
	/// It's all working well, but let me show you one thing, which must be noted when using the universal overlay modifier.
	// @State private var text: String = ""
	
	var body: some View {
		NavigationStack {
			List {
				// TextField("Message", text: $text)
				
				Button("Floating Video") {
					show.toggle()
				}
				.tint(.blue)
				/// It will add the view on top the entire SwiftUI App, so you can use it anywhere in your code.
				.universalOverlay(show: $show) {
//					Circle()
//						.fill(.red)
					/// When you try to access the current view's state properties inside the wrapper, it will have no effect on it. The simple way to solve this is to simply create a new view struct and pass the necessary properties as binding properties.
					/// If you have observable objects, then pass them as environment objects and use them in the view struct.
//						.overlay {
//							Text("\(text)")
//						}
//						.frame(width: 50, height: 50)
//						.onTapGesture {
//							print("Tapped")
//						}
					FloatingVideoPlayerView(
						show: $show
						// text: $text
					)
				}
				
				Button("Show Dummy Sheet") {
					showSheet.toggle()
				}
				.tint(.blue)
			}
			.navigationTitle("Universal Overlay")
		}
		.sheet(isPresented: $showSheet) {
			Text("Hello from Sheets!!")
		}
	}
}

struct FloatingVideoPlayerView: View {
	@Binding var show: Bool
	// @Binding var text: String
	
	// View Properties
	@State private var player: AVPlayer?
	@State private var offset: CGSize = .zero
	@State private var lastStoredOffset: CGSize = .zero
	
	var body: some View {
//		Circle()
//			.fill(.red)
//			.overlay {
//				Text("\(text)")
//			}
//			.frame(width: 50, height: 50)
//			.onTapGesture {
//				print("Tapped")
//			}
		GeometryReader {
			let size = $0.size
			Group {
				if let videoURL {
					VideoPlayer(player: player)
						.background(.black)
						.clipShape(.rect(cornerRadius: 25))
				} else {
					RoundedRectangle(cornerRadius: 25)
				}
			}
			.frame(height: 250)
			.offset(offset)
			.gesture(
				DragGesture()
					.onChanged { value in
						let translation = value.translation + lastStoredOffset
						offset = translation
					}
					.onEnded { value in
						withAnimation(.bouncy) {
							/// Limiting to not move away from the screen
							offset.width = 0
							if offset.height < 0 {
								offset.height = 0
							}
							
							if offset.height > (size.height - 250) {
								offset.height = (size.height - 250)
							}
						}
						
						lastStoredOffset = offset
					}
			)
			.frame(maxHeight: .infinity, alignment: .top)
		}
		.padding(.horizontal)
		.transition(.blurReplace)
		.onAppear {
			if let videoURL {
				print(videoURL)
				player = AVPlayer(url: videoURL)
				player?.play()
			}
		}
	}
	
	/// And that's it. We successfully created a universal overlay modifier that will add the view on top of the entire SwiftUl app.
	/// Now let me show you how you can create a floating video player, which you've seen in the intro video, with the help of this modifier.
	var videoURL: URL? {
//		if let path = Bundle.main.path(forResource: "Reel 2", ofType: "mp4") {
//			return .init(string: path)
//		}
//		return nil
		return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
	}
}

//extension CGSize {
//	static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
//		return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
//	}
//}

/// If you want previews to be working, then you must need to wrap your preview view with the RootView Wrapper.
#Preview {
	UniRootView {
		UniversalOverlayContentView()
	}
}
