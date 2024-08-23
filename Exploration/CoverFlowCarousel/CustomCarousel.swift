import SwiftUI

// Custom View
struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
	var config: Config
	@Binding var selection: Data.Element.ID?
	var data: Data
	@ViewBuilder var content: (Data.Element) -> Content
	
	var body: some View {
		GeometryReader {
			/// Sometimes the Size value in the GeometryReader will be zero at initial/load time. Let's fix this issue by simply capping the values with a maximum of zero.
			/// When it happens you'd get "invalid frame dimension (negative or non-finite)
			let size = $0.size
			
			ScrollView(.horizontal) {
				/// NOTE:
				/// Because we use the offset modifier to relocate the items to create the carousel view. This means that when using LazyHStack, the views at the leading and trailing ends may not be visible until the real Item View reaches the screen space.
				HStack(spacing: config.spacing) {
					ForEach(data) { item in
						ItemView(item)
					}
				}
				.scrollTargetLayout()
			}
			/// Making it to start and end at the center.
			// .safeAreaPadding(.horizontal, (size.width - config.cardWidth) / 2)
			.safeAreaPadding(.horizontal, max((size.width - config.cardWidth) / 2, 0))
			.scrollPosition(id: $selection)
			// Make it paginate
			.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
			.scrollIndicators(.hidden)
		}
	}
	
	@ViewBuilder func ItemView(_ item: Data.Element) -> some View {
		GeometryReader { proxy in
			let size = proxy.size
			
			let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
			let progress = minX / (config.cardWidth + config.spacing)
			let minimumCardWidth = config.minimumCardWidth
			
			let diffWidth = config.cardWidth - minimumCardWidth
			let reducingWidth = progress * diffWidth
			/// Limiting diffWidth as the max value
			let cappedWidth = min(reducingWidth, diffWidth)
			let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
			let negativeProgress = max(-progress, 0)
			
			let scaleValue = config.scaleValue * abs(progress)
			let opacityValue = config.opacityValue * abs(progress)
			
			content(item)
				.frame(width: size.width, height: size.height)
				.frame(width: resizedFrameWidth)
				.opacity(config.hasOpacity ? 1 - opacityValue : 1)
				.scaleEffect(config.hasScale ? 1 - scaleValue : 1)
				/// As you can see, when applying scaling, the view is not clipped properly. This is because the clipping modifier is applied after the scale modifier. Let's solve this issue by using the mask modifier to dynamically change its mask height based on the scaling value.
				// .clipShape(.rect(cornerRadius: config.cornerRadius))
				.mask {
					let hasScale = config.hasScale
					let scaledHeight = (1 - scaleValue) * size.height
					RoundedRectangle(cornerRadius: config.cornerRadius)
						.frame(height: hasScale ? max(scaledHeight, 0) : size.height)
				}
				.offset(x: -reducingWidth)
				.offset(x: min(progress, 1) * diffWidth)
				.offset(x: negativeProgress * diffWidth)
		}
		.frame(width: config.cardWidth)
	}
	
	// Config
	// You can add more configurations if you wish.
	struct Config {
		var hasOpacity: Bool = false
		var opacityValue: CGFloat = 0.4
		var hasScale: Bool = false
		var scaleValue: CGFloat = 0.2
		
		var cardWidth: CGFloat = 150
		var spacing: CGFloat = 10
		var cornerRadius: CGFloat = 15
		var minimumCardWidth: CGFloat = 40
	}
}

#Preview {
	CoverFlowContentView()
}
