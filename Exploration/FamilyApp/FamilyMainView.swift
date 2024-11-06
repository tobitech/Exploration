import SwiftUI

enum FamilyTab {
	case history
	case wallets
	case browser
}

struct FamilyMainView: View {
	@Binding var showScanView: Bool
	@State private var selectedTab: FamilyTab = .history

	var body: some View {
		ZStack {
			VStack(spacing: 10) {
				Capsule()
					.fill(.primary.quinary)
					.frame(width: 35, height: 5)
					.offset(y: 10)
				
				TabView(selection: $selectedTab) {
					// Your tabs go here
					HistoryView(scanAction: {
						showScanView.toggle()
					})
					.tabItem {
						Label("History", systemImage: "clock")
					}
					.tag(FamilyTab.history)
					Text("Wallets")
						.tabItem {
							Label("Wallets", systemImage: "wallet.pass")
						}
						.tag(FamilyTab.wallets)
					Text("Browser")
						.tabItem {
							Label("Browser", systemImage: "globe")
						}
						.tag(FamilyTab.browser)
				}
			}
			.background(.background)

			if showScanView {
				Rectangle()
					.fill(.background.opacity(0.1))
					.onTapGesture {
						showScanView = false
					}
			}
		}
	}
}

struct HistoryView: View {
	var scanAction: () -> Void
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "chart.pie.fill")
					.font(.title2)
				Spacer()
				Button {
					scanAction()
				} label: {
					Image(systemName: "viewfinder")
						.font(.title2)
				}
			}
			Divider()
				.padding(.top, 10)
			Spacer()
			Text("History")
			Spacer()
		}
		.padding()
	}
}

#Preview {
	FamilyRootView()
}
