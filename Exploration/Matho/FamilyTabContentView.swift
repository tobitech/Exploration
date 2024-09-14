import SwiftUI

// Enum to hold the tabs
enum Tab: String, CaseIterable, Identifiable {
	case overview
	case transactions
	case goals
	case budget
	case recurring
	
	var id: String { self.rawValue }
	
	var title: String {
		switch self {
		case .overview: return "Overview"
		case .transactions: return "Transactions"
		case .goals: return "Goals"
		case .budget: return "Budget"
		case .recurring: return "Recurring"
		}
	}
	
	var iconName: String {
		switch self {
		case .overview: return "house.fill"
		case .transactions: return "list.bullet.rectangle"
		case .goals: return "target"
		case .budget: return "chart.pie.fill"
		case .recurring: return "repeat"
		}
	}
}

struct FamilyTabContentView: View {
	@State private var selectedTab: Tab = .overview
	@State private var previousTab: Tab = .overview
	
	var body: some View {
		VStack(spacing: 0) {
			// Content area
			ZStack {
				ForEach([Tab.overview, .transactions]) { tab in
					// if tab == selectedTab || tab == previousTab {
						tabView(for: tab)
							.transition(transition(for: tab))
							.zIndex(tab == selectedTab ? 1 : 0)
					// }
				}
			}
			.animation(
				.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0),
				value: selectedTab
			)
			
			Divider()
			
			// Bottom navigation bar
			HStack {
				ForEach([Tab.overview, .transactions]) { tab in
					Button(action: {
						if tab != selectedTab {
							withAnimation {
								self.previousTab = self.selectedTab
								self.selectedTab = tab
							}
						}
					}) {
						VStack(spacing: 4) {
							Image(systemName: tab.iconName)
								.font(.system(size: 22))
						}
						.foregroundColor(tab == selectedTab ? .blue : .gray)
						.frame(maxWidth: .infinity)
					}
				}
			}
			.padding(.vertical, 10)
			.background(Color(UIColor.systemBackground))
		}
	}
	
	// Function to provide the content view for each tab
	func tabView(for tab: Tab) -> some View {
		switch tab {
		case .overview:
			return AnyView(OvervView())
		case .transactions:
			return AnyView(TransactionsView())
		case .goals:
			return AnyView(GoalsView())
		case .budget:
			return AnyView(BudgetView())
		case .recurring:
			return AnyView(RecurringView())
		}
	}
	
	// Corrected transition function
	func transition(for tab: Tab) -> AnyTransition {
			guard let fromIndex = [Tab.overview, .transactions].firstIndex(of: previousTab),
						let toIndex = [Tab.overview, .transactions].firstIndex(of: selectedTab) else {
					return .identity
			}
		
		if toIndex > fromIndex {
			return .asymmetric(
				insertion: .move(edge: .trailing),
				removal: .move(edge: .trailing)
		 )
		} else if toIndex < fromIndex {
			return .asymmetric(
				insertion: .move(edge: .leading),
				removal: .move(edge: .leading)
		 )
		} else {
			return .identity
		}
		
		/*
			if tab == selectedTab {
					// Incoming view
					if toIndex > fromIndex {
							// Slide in from the right
							return .asymmetric(
									insertion: .move(edge: .trailing),
									removal: .move(edge: .leading)
							)
					} else if toIndex < fromIndex {
							// Slide in from the left
							return .asymmetric(
									insertion: .move(edge: .leading),
									removal: .move(edge: .trailing)
							)
					} else {
							return .identity
					}
			} else if tab == previousTab {
					// Outgoing view
					if toIndex > fromIndex {
							// Slide out to the left
							return .asymmetric(
									insertion: .move(edge: .trailing),
									removal: .move(edge: .leading)
							)
					} else if toIndex < fromIndex {
							// Slide out to the right
							return .asymmetric(
									insertion: .move(edge: .leading),
									removal: .move(edge: .trailing)
							)
					} else {
							return .identity
					}
			}

			return .identity
		 */
	}

}

// Placeholder views for each tab
struct OvervView: View {
	var body: some View {
		Color(.systemBackground)
			.overlay(
				Text("Overview")
					.font(.largeTitle)
					.bold()
			)
	}
}

struct TransactionsView: View {
	var body: some View {
		Color(.systemBackground)
			.overlay(
				Text("Transactions")
					.font(.largeTitle)
					.bold()
			)
	}
}

struct GoalsView: View {
	var body: some View {
		Color(.systemBackground)
			.overlay(
				Text("Goals")
					.font(.largeTitle)
					.bold()
			)
	}
}

struct BudgetView: View {
	var body: some View {
		Color(.systemBackground)
			.overlay(
				Text("Budget")
					.font(.largeTitle)
					.bold()
			)
	}
}

struct RecurringView: View {
	var body: some View {
		Color(.systemBackground)
			.overlay(
				Text("Recurring")
					.font(.largeTitle)
					.bold()
			)
	}
}


#Preview {
	FamilyTabContentView()
}
