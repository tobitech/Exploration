import SwiftUI

struct NotificationItem: Identifiable {
	var id = UUID()
	var logo: String
	var title: String
	var description: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
}

var notificationItems: [NotificationItem] = [
	/// Let's make an empty item at the top so that the initial view will be empty and the stack appears only when the view is scrolled up, which automatically enables the possibility to hide the stack view by scrolling down, just like the iOS lock screen.
	NotificationItem(logo: "", title: ""),
	NotificationItem(logo: "amazon", title: "Amazon"),
	NotificationItem(logo: "apple", title: "Apple"),
	NotificationItem(logo: "bittorrent", title: "Bittorrent"),
	NotificationItem(logo: "buzzfeed", title: "Buzzfeed"),
	NotificationItem(logo: "dailymotion", title: "Daily Motion"),
	NotificationItem(logo: "discord", title: "Discord"),
	NotificationItem(logo: "dribbble", title: "Dribbble"),
	NotificationItem(logo: "facebook", title: "Facebook"),
	NotificationItem(logo: "figma", title: "Figma"),
	NotificationItem(logo: "fancy", title: "Fancy"),
	NotificationItem(logo: "firefox", title: "Firefox")
]
