import SwiftUI
import UIKit

struct InboxView: View {
	var body: some View {
		List(0..<20, id: \.self) { i in
			HStack(alignment: .top) {
				Image(systemName: "envelope.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundStyle(.gray.opacity(0.2))
					.frame(width: 32, height: 32)
				VStack(alignment: .leading) {
					HStack {
						Text("Message \(i)")
						Spacer()
						Text("Aug 20")
							.font(.footnote)
					}
					Text(
						"All the Button syntax errors are now fixed. The label parameter now correctly uses the colon syntax label"
					)
				}
			}
			.foregroundStyle(.secondary)
		}
		.listStyle(.plain)
		.listSectionSeparator(.hidden)
		.navigationBarTitleDisplayMode(.inline)  // inline => left-aligned title area
		.toolbar(content: {
			// Custom title view placed in the title slot
			ToolbarItem(placement: .topBarLeading) {
				HStack(spacing: 16) {
					Image(systemName: "tray.fill")
						.imageScale(.large)
						.font(.title3)  // scales with Dynamic Type
						.foregroundStyle(.red)
					Text("Inbox")
						.font(.title2).fontWeight(.medium)
				}
				.accessibilityElement(children: .combine)
			}

			ToolbarItem(placement: .navigationBarTrailing) {
				HStack(spacing: 12) {
					Button { /* filters */
					} label: {
						Image(systemName: "line.3.horizontal.decrease")
					}
					.tint(.black)
					Button { /* stats  */
					} label: {
						Image(systemName: "chart.pie.fill")
					}
					.tint(.green)
				}
			}
		})
	}
}

struct RatioView: View {
	@State private var activeTab: FloatingTab = .home
	
	init() {
	}
	
	var body: some View {
		TabView(selection: $activeTab) {
			Tab("", systemImage: "chart.pie.fill", value: .home) {
				NavigationStack {
					List(0..<20, id: \.self) { i in
						HStack(alignment: .top) {
							Image(systemName: "creditcard.circle.fill")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.foregroundStyle(.gray.opacity(0.2))
								.frame(width: 32, height: 32)
							VStack(alignment: .leading) {
								HStack {
									Text("Walmart \(i)")
									Spacer()
									Text("Aug 20")
										.font(.footnote)
								}
								Text(
									"All the Button syntax errors are now fixed. The label parameter now correctly uses the colon syntax label"
								)
							}
						}
						.foregroundStyle(.secondary)
						.swipeActions(edge: .trailing) {
							Button {
								// Split transaction
							} label: {
								Image(systemName: "scissors")
							}
							.tint(.orange)

							Button {
								// Dispute transaction
							} label: {
								Image(systemName: "exclamationmark.triangle")
							}
							.tint(.red)
						}
						.swipeActions(edge: .leading) {
							Button {
								// Categorize transaction
							} label: {
								Image(systemName: "folder")
							}
							.tint(.blue)

							Button {
								// Flag for review
							} label: {
								Image(systemName: "flag")
							}
							.tint(.purple)
						}
					}
					.listStyle(.plain)
					.listSectionSeparator(.hidden)
					.searchable(text: .constant(""), prompt: "Ask anything")
					.navigationBarTitleDisplayMode(.inline)  // inline => left-aligned title area
					.toolbar {
						// Custom title view placed in the title slot
						ToolbarItem(placement: .topBarLeading) {
							HStack(alignment: .top, spacing: 16) {
								Image(systemName: "chart.bar.fill")
									.font(.title3)  // scales with Dynamic Type
									.foregroundStyle(.red)
								Text("Insights")
									.font(.title2).fontWeight(.medium)
							}
							.accessibilityElement(children: .combine)
						}

						ToolbarItem(placement: .navigationBarTrailing) {
							HStack(spacing: 12) {
								Button { /* filters */
								} label: {
									Image(systemName: "line.3.horizontal.decrease")
										.fontWeight(.medium)
								}
								.tint(.black)
								Button { /* stats  */
								} label: {
									Image(systemName: "dollarsign.bank.building")
										.fontWeight(.medium)
								}
								.tint(.black)
							}
						}
					}
				}
				.background {
					HideTabBar {}
				}
			}

			Tab("", systemImage: "chart.bar", value: .search) {
				Text("Overview")
			}

			Tab("", systemImage: "gearshape", value: .settings) {
				Text("Settings")
			}
		}
		.safeAreaInset(edge: .bottom) {
			TabBar()
				.frame(height: 49)
				.background(.regularMaterial)
		}
	}
	
	@ViewBuilder
	func TabBar() -> some View {
		HStack(spacing: 0) {
			ForEach(FloatingTab.allCases, id: \.rawValue) { tab in
				Button(action: { activeTab = tab }, label: {
					VStack {
						Image(systemName: "chart.pie.fill")
							.font(.title2)
					}
					.foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.contentShape(.rect)
				})
				.buttonStyle(.plain)
			}
		}
	}
}

extension UITabBar {
	func removeTabbarItemsText() {
		items?.forEach {
			$0.title = ""
			$0.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
		}
	}
}

//#Preview("Notion Mail") {
//	NavigationStack {
//		InboxView()
//	}
//}
#Preview("Ratio Money") {
	RatioView()
}
