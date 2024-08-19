import SwiftUI

enum FloatingTab: String, CaseIterable {
	case home = "house"
	case search = "magnifyingglass"
	case notifications = "bell"
	case settings = "gearshape"
	
	var title: String {
		switch self {
		case .home: "Home"
		case .search: "Search"
		case .notifications: "Notifications"
		case .settings: "Settings"
		}
	}
}
