import Charts
import SwiftUI

struct ToyShape: Identifiable {
	var type: String
	var count: Double
	var id = UUID()
}

struct CashFlowView: View {
	var data: [ToyShape] = [
		.init(type: "Cube", count: 5),
		.init(type: "Sphere", count: 4),
		.init(type: "Pyramid", count: 4)
	]
	
	var body: some View {
		HStack {
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
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			
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
			.foregroundStyle(.gray.gradient)
			.chartXAxis(.hidden)
			.chartYAxis(.hidden)
			.frame(width: 50, height: 40)
		}
		.padding()
	}
}

#Preview {
	RatioContentView()
}
