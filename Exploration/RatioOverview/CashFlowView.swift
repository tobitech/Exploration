import Charts
import SwiftUI

struct ToyShape: Identifiable {
	var type: String
	var count: Double
	var id = UUID()
}

struct CashFlowView: View {
	@State private var showIncome: Bool = false
	
	var data: [ToyShape] = [
		.init(type: "Cube", count: 5),
		.init(type: "Sphere", count: 4),
		.init(type: "Pyramid", count: 4)
	]
	
	var body: some View {
		HStack {
			if showIncome {
				VStack(alignment: .leading) {
					Text("Cash flow this month")
						.font(.subheadline)
						.fontWeight(.medium)
						// .textCase(.uppercase)
						.foregroundStyle(.secondary)
					VStack(alignment: .leading) {
						Text("$193.78")
							.font(.largeTitle)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
					// Divider()
					VStack(alignment: .leading) {
						Text("$193.78")
							.font(.title3)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
				}
				.frame(maxWidth: .infinity, alignment: .topLeading)
			} else {
				VStack(alignment: .leading) {
					// Label("Spent this month",systemImage: "banknote")
					Text("Spent this month")
						.font(.subheadline)
						.fontWeight(.medium)
						// .textCase(.uppercase)
						.foregroundStyle(.secondary)
					Text("$193.78")
						.font(.system(size: 40))
				}
				.foregroundStyle(.white)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			}
			Spacer()
			// TODO: - Check Horizontal Scrolling Bar Chart in the repo below to make a cash flow chart
			// - https://github.com/jordibruin/Swift-Charts-Examples?tab=readme-ov-file
			Chart {
				BarMark(
					x: .value("Shape Type", data[0].type),
					y: .value("Total Count", data[0].count)
				)
				.foregroundStyle(.tertiary)
				.cornerRadius(3, style: .continuous)
				BarMark(
					x: .value("Shape Type", data[1].type),
					y: .value("Total Count", data[1].count)
				)
				.foregroundStyle(.tertiary)
				.cornerRadius(3, style: .continuous)
				BarMark(
					x: .value("Shape Type", data[2].type),
					y: .value("Total Count", data[2].count)
				)
				.foregroundStyle(.tertiary)
				.cornerRadius(3, style: .continuous)
			}
			.foregroundStyle(.white.gradient)
			.chartXAxis(.hidden)
			.chartYAxis(.hidden)
			.frame(width: 100, height: 60)
		}
		.padding()
		.background(.green, in: .rect(cornerRadius: 20, style: .continuous))
	}
}

#Preview {
	RatioContentView()
}
