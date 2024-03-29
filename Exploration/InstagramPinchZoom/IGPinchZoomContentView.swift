// Source - https://youtu.be/Z1_49kXP5U0?si=SFX5d27LULDgoKKw

import SwiftUI

struct IGPinchZoomContentView: View {
	var body: some View {
		ZoomContainer {
			TabView {
				NavigationStack {
					ScrollView {
						VStack(spacing: 15) {
							ForEach(igPosts) {
								IGCardView($0)
							}
						}
						.padding(15)
					}
					.navigationTitle("Instagram")
				}
				.tabItem { Label("Home", systemImage: "house") }
				
				Text("Profile")
					.tabItem { Label("Profile", systemImage: "person.circle") }
			}
		}
	}
	
	@ViewBuilder
	func IGCardView(_ post: IGPost) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			GeometryReader {
				let size = $0.size
				Image(post.image)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipShape(.rect(cornerRadius: 10))
					.pinchZoom()
			}
			.frame(height: 240)
			
			HStack(spacing: 12) {
				VStack(alignment: .leading, spacing: 2) {
					Text(post.title)
						.font(.callout)
						.lineLimit(2)
						.multilineTextAlignment(.leading)
					
					Text("By " + post.author)
						.font(.caption)
						.foregroundStyle(.secondary)
				}
				
				Spacer()
				
				if let link = URL(string: post.url) {
					Link("Visit", destination: link)
						.font(.caption)
						.buttonStyle(.bordered)
						.buttonBorderShape(.capsule)
						.tint(.blue)
				}
			}
			.padding(.horizontal, 10)
		}
	}
}

#Preview {
	IGPinchZoomContentView()
}
