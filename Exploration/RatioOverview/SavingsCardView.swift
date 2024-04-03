import Charts
import SwiftUI

func date(year: Int, month: Int, day: Int = 1) -> Date {
		Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

struct SavingsCardView: View {
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			// Label("Savings", systemImage: "magsafe.batterypack")
			Text("Savings")
				.font(.footnote)
				.fontWeight(.medium)
				// .textCase(.uppercase)
				.foregroundStyle(.secondary)
			Text("$684")
				.font(.title)
				// .fontWeight(.medium)
				.padding(.top, 5)
			Chart {
				LineMark(
					x: .value("Day", date(year: 2024, month: 1), unit: .day),
					y: .value("Sales", 2)
				)
				LineMark(
					x: .value("Day", date(year: 2024, month: 2), unit: .day),
					y: .value("Sales", 1)
				)
				LineMark(
					x: .value("Day", date(year: 2024, month: 3), unit: .day),
					y: .value("Sales", 5)
				)
				LineMark(
					x: .value("Day", date(year: 2024, month: 4), unit: .day),
					y: .value("Sales", 7)
				)
			}
			.chartXAxis(.hidden)
			.chartYAxis(.hidden)
			.frame(height: 30)
			
			Spacer()
			HStack(alignment: .bottom) {
				Text("Savings to\nExpense Ratio")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
				Spacer()
				Text("0.78")
					.font(.subheadline)
					.fontWeight(.medium)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.frame(height: 130)
		.padding()
		.background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
