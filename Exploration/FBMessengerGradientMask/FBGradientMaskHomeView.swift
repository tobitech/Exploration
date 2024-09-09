import SwiftUI

struct FBGradientMaskHomeView: View {
	var body: some View {
		GeometryReader { proxy in
			ScrollView(.vertical) {
				LazyVStack(spacing: 15) {
					ForEach(fbMessages) { message in
						MessageCardView(screenProxy: proxy, message: message)
					}
				}
				.padding()
			}
		}
	}
}

struct MessageCardView: View {
	var screenProxy: GeometryProxy
	var message: FBMessage
	var body: some View {
		Text(message.message)
			.padding(10)
			.foregroundStyle(message.isReply ? Color.primary : .white)
			.background {
				if message.isReply {
					RoundedRectangle(cornerRadius: 15)
						.fill(.gray.opacity(0.3))
				} else {
					GeometryReader {
						/// First, we must extend the background to fit the actual screen or scrollview size. We can use a geometry reader to retrieve the screen or scrollview size.
						let actualSize = $0.size
						let screenSize = screenProxy.size
						let safeArea = screenProxy.safeAreaInsets
						
						/// Next, we need to adjust this view to match the scrollview frame. This will be very simple because we already know the bounds of the actual background and can use those values to reposition this view.
						let rect = $0.frame(in: .global)
						
						Rectangle()
							.fill(
								.linearGradient(
									colors: [
										Color("FBC1"),
										Color("FBC2"),
										Color("FBC3"),
										Color("FBC3"),
										Color("FBC4"),
										Color("FBC4")
									],
									startPoint: .top,
									endPoint: .bottom
								)
							)
						/// Now we can use the mask modifier to mask the actual background portion, which in turn will create a dynamic gradient background effect.
						/// The reason why the gradient is dynamically updated when the view is scrolled is that the background geometry will be updated whenever the view gets scrolled, which means the mask modifier will be moved dynamically as per the geometry values, thus creating a dynamic gradient background effect.
							.mask(alignment: .topLeading) {
								RoundedRectangle(cornerRadius: 15)
									.frame(width: actualSize.width, height: actualSize.height)
									.offset(x: rect.minX, y: rect.minY)
							}
							.offset(x: -rect.minX, y: -rect.minY)
						/// Since I'm using the global namespace here, which means the view position is calculated from the safe areas, including the safe area top and bottom values in the height will solve this issue.
							.frame(width: screenSize.width, height: screenSize.height + safeArea.top + safeArea.bottom)
					}
				}
			}
			.frame(maxWidth: 250, alignment: message.isReply ? .leading : .trailing)
			.frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
	}
}

#Preview {
	FBGradientMaskContentView()
}
