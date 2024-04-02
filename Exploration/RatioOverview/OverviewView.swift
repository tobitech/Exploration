import SwiftUI

struct OverviewView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				GeometryReader { geometry in
					VStack {
						CashFlowView()
						let size = geometry.size
						let width = (size.width - 16) / 2
						LazyVGrid(columns: [GridItem(.fixed(width)), GridItem(.fixed(width))], spacing: 10, content: {
							SavingsCardView()
							NetworthCardView()
							DebtCardView()
							ListsCardView()
						})
						UpcomingListView()
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
				}
				.padding(10)
			}
			.navigationTitle("Overview")
		}
	}
}

#Preview {
	RatioContentView()
}
