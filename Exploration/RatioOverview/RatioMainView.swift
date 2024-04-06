import SwiftUI

enum RatioTab {
	case overview
	case insights
	case profile
}

struct RatioMainView: View {
	@State private var selectedTab: RatioTab = .overview
	
	var body: some View {
		TabView(selection: $selectedTab) {
			OverviewView()
				.tabItem {
					Label("Overview", systemImage: "chart.pie")
				}
			Text("Transactions")
				.tabItem {
					Label("Transactions", systemImage: "square.stack.3d.up")
				}
			Text("Budgeting")
				.tabItem {
					Label("Budgeting", systemImage: "doc.plaintext")
				}
			Text("Goals")
				.tabItem {
					Label("Goals", systemImage: "target")
				}
			Text("Profile")
				.tabItem {
					Label("Profile", systemImage: "person")
				}
		}
		.toolbarBackground(.visible, for: .tabBar)
	}
}

#Preview {
	RatioContentView()
}
