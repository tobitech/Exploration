import SwiftUI

struct StackedNotificationsHomeView: View {
	var body: some View {
		VStack {
			StackedCards(items: notificationItems, stackedDisplayCount: 1, opacityDisplayCount: 0, itemHeight: 70) { item in
				CardView(item)
			}
			.padding(.bottom, 20)
			
			BottomActionBar()
		}
		.padding(20)
	}
	
	// Card View
	@ViewBuilder
	func CardView(_ item: NotificationItem) -> some View {
		/// Let's make an empty item at the top so that the initial view will be empty and the stack appears only when the view is scrolled up, which automatically enables the possibility to hide the stack view by scrolling down, just like the iOS lock screen.
		if item.logo.isEmpty {
			Rectangle()
				.fill(.clear)
		} else {
			HStack(spacing: 12) {
				Image(item.logo)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 40, height: 40)
				
				VStack(alignment: .leading, spacing: 4) {
					Text(item.title)
						.font(.callout)
						.fontWeight(.bold)
					
					Text(item.description)
						.font(.caption)
						.lineLimit(1)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding(10)
			.frame(maxHeight: .infinity)
			.background(.ultraThinMaterial)
			.clipShape(.rect(cornerRadius: 20))
		}
	}
	
	// Bottom Action Bar
	@ViewBuilder
	func BottomActionBar() -> some View {
		HStack {
			Button {
				
			} label: {
				Image(systemName: "flashlight.off.fill")
					.font(.title3)
					.frame(width: 35, height: 35)
			}
			.buttonStyle(.borderedProminent)
			.tint(.white.opacity(0.2))
			.buttonBorderShape(.circle)
			
			Spacer()
			
			Button {
				
			} label: {
				Image(systemName: "camera.fill")
					.font(.title3)
					.frame(width: 35, height: 35)
			}
			.buttonStyle(.borderedProminent)
			.tint(.white.opacity(0.2))
			.buttonBorderShape(.circle)
		}
	}
}

#Preview {
	StackedNotificationsContentView()
}
