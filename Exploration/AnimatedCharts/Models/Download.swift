import Foundation

struct Download: Identifiable {
	var id = UUID()
	var date: Date
	var value: Double
	// Animatable Properties
	var isAnimated: Bool = false
	
	var month: String {
		date.formatted(.dateTime.month(.abbreviated))
	}
}

var sampleDownloads: [Download] = [
	.init(date: .createDate(1, 8, 2023), value: 2500),
	.init(date: .createDate(1, 9, 2023), value: 3500),
	.init(date: .createDate(1, 10, 2023), value: 1500),
	.init(date: .createDate(1, 11, 2023), value: 9500),
	.init(date: .createDate(1, 12, 2023), value: 1950),
	.init(date: .createDate(1, 1, 2024), value: 5100)
]

extension Date {
	static func createDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
		var components = DateComponents()
		components.day = day
		components.month = month
		components.year = year
		let calendar = Calendar.current
		let date = calendar.date(from: components) ?? .init()
		return date
	}
}
