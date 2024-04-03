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
			Text("Insights")
				.tabItem {
					Label("Insights", systemImage: "chart.bar")
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
