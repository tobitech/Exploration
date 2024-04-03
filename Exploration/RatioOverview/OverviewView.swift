import SwiftUI

struct OverviewView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				GeometryReader { geometry in
					let size = geometry.size
					let width = (size.width - 16) / 2
					VStack {
						CashFlowView()
						// ReportCardView()
						UpcomingListView()
						LazyVGrid(columns: [GridItem(.fixed(width)), GridItem(.fixed(width))], spacing: 10, content: {
							SavingsCardView()
							NetworthCardView()
							DebtCardView()
							ListsCardView()
						})
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
				}
				.padding(10)
			}
			.scrollBounceBehavior(.always)
			.navigationTitle("Overview")
		}
	}
}

#Preview {
	RatioContentView()
}
