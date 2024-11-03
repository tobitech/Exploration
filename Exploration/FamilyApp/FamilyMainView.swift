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
			VStack {
				if showScanView {
					HStack {
						Spacer()
						RoundedRectangle(cornerRadius: 2)
							.fill(.quaternary)
							.frame(width: 40, height: 4)
						Spacer()
					}
					.padding(10)
					.foregroundStyle(.primary)
				}
				
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
