import SwiftUI

struct CalendarScrollAnimationHomeView: View {
	// View Properties
	@State private var selectedMonth: Date = .currentMonth
	@State private var selectedDate: Date = .now
	
	var safeArea: EdgeInsets
	
	var body: some View {
		let maxHeight = calendarHeight - (calendarTitleViewHeight + weekLabelHeight + safeArea.top + 50 + topPadding + bottomPadding - 50)
		ScrollView(.vertical) {
			VStack(spacing: 0) {
				CalendarView()
				
				VStack(spacing: 15) {
					ForEach(1...15, id: \.self) { _ in
						CardView()
					}
				}
				.padding(15)
			}
		}
		.scrollIndicators(.hidden)
		/// So now, when the scroll is finished before the maximum height, it will reset to its initial position. Otherwise, it will end in its desired position.
		.scrollTargetBehavior(CustomScrollBehaviour(maxHeight: maxHeight))
	}
	
	// Test Card View (For Scroll Content)
	@ViewBuilder
	func CardView() -> some View {
		RoundedRectangle(cornerRadius: 15)
			.fill(.blue.gradient)
			.frame(height: 70)
			.overlay(alignment: .leading) {
				HStack(spacing: 12) {
					Circle()
						.frame(width: 40, height: 40)
					VStack(alignment: .leading, spacing: 6) {
						RoundedRectangle(cornerRadius: 5)
							.frame(width: 100, height: 5)
						RoundedRectangle(cornerRadius: 5)
							.frame(width: 70, height: 5)
					}
				}
				.foregroundStyle(.white.opacity(0.25))
				.padding(15)
			}
	}
	
	// Calendar View
	@ViewBuilder
	func CalendarView() -> some View {
		/// As you can already know, the geometry reader needs explicit height. This is the reason why I maintained each view with a height tag, and now we can merge all their heights to get the exact height value for the geometry reader.
		GeometryReader {
			let size = $0.size
			let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
			
			// Converting Scroll into Progress
			/// So I simply didn't add the calendar grid height, which results in the view exactly stopping before the grid view. Now what I need is to simply display a single row of the grid view, and as we know, each grid row height is 50, Thus, adding 50 to the max height will result in the view stopping at the first row of the grid view.
			/// Since the title moved up by 50 removing 50 from maxHeight should fix the header position.
			let maxHeight = size.height - (calendarTitleViewHeight + weekLabelHeight + safeArea.top + 50 + topPadding + bottomPadding - 50)
			let progress = max(min((-minY / maxHeight), 1), 0)
			
			VStack(alignment: .leading, spacing: 0) {
				Text(currentMonth)
					.font(.system(size: 35 - (10 * progress)))
					.offset(y: -50 * progress)
					.frame(maxHeight: .infinity, alignment: .bottom)
					.overlay(alignment: .topLeading) {
						GeometryReader {
							let size = $0.size
							Text(year)
								.font(.system(size: 25 - (10 * progress)))
								.offset(x: (size.width + 5) * progress, y: progress * 3)
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.overlay(alignment: .topTrailing) {
						HStack(spacing: 15) {
							Button("", systemImage: "chevron.left") {
								// Update to previous month
								monthUpdate(false)
							}
							.contentShape(.rect)
							Button("", systemImage: "chevron.right") {
								// Update to next month
								monthUpdate(true)
							}
							.contentShape(.rect)
						}
						.font(.title3)
						.foregroundStyle(.primary)
						.offset(x: 150 * progress)
					}
					.frame(height: calendarTitleViewHeight)
				
				VStack(spacing: 0) {
					// Day Labels
					HStack(spacing: 0) {
						ForEach(Calendar.autoupdatingCurrent.weekdaySymbols, id: \.self) { symbol in
							Text(symbol.prefix(3))
								.font(.caption)
								.frame(maxWidth: .infinity)
								.foregroundStyle(.secondary)
						}
					}
					.frame(height: weekLabelHeight, alignment: .bottom)
					
					// Calendar Grid View
					LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0, content: {
						ForEach(selectedMonthDates) { day in
							Text(day.shortSymbol)
								.foregroundStyle(day.ignored ? .secondary : .primary)
								.frame(maxWidth: .infinity)
								.frame(height: 50)
								.overlay(alignment: .bottom) {
									Circle()
										.fill(.white)
										.frame(width: 5, height: 5)
										.opacity(Calendar.current.isDate(day.date, inSameDayAs: selectedDate) ? 1 : 0)
									// Moving the indicator a little bit above.
										.offset(y: progress * -2)
								}
								.contentShape(.rect)
								.onTapGesture {
									selectedDate = day.date
								}
						}
					})
					/// As you can notice, the selection changes to upcoming weeks even though there is no visibility of those dates, so what l'm ! going to do is clip the boundaries of the grid view by changing the grid view height to only 50 based on the scroll progress, Thus, it will clip its boundaries and avoid unwanted interactions.
					.frame(height: calendarGridHeight - ((calendarGridHeight - 50) * progress), alignment: .top)
					.offset(y: (monthProgress * -50) * progress)
					.contentShape(.rect)
					.clipped()
				}
				.offset(y: progress * -50)
			}
			.foregroundStyle(.white)
			.padding(.horizontal, horizontalPadding)
			.padding(.top, topPadding)
			.padding(.top, safeArea.top)
			.padding(.bottom, bottomPadding)
			.frame(maxHeight: .infinity)
			.frame(height: size.height - (maxHeight * progress), alignment: .top)
			.background(.red.gradient)
			// Sticking it to the top
			.clipped()
			.contentShape(.rect)
			.offset(y: -minY) // Applying offset before content shape doesn't allow interaction here.
		}
		.frame(height: calendarHeight)
		.zIndex(1000)
	}
	
	// Date Formatter
	func format(_ format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: selectedMonth)
	}
	
	// Month Increment/Decrement
	func monthUpdate(_ increment: Bool = true) {
		let calendar = Calendar.autoupdatingCurrent
		guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth) else { return }
		// Update selected date when month changes.
		guard let date = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedDate) else { return }
		selectedMonth = month
		selectedDate = date
	}
	
	// Selected Month Dates
	var selectedMonthDates: [Day] {
		return extractDates(selectedMonth)
	}
	
	// Current Month String
	var currentMonth: String {
		return format("MMMM")
	}
	
	/// To show selected week when we scroll.
	/// In order to get the precise row value where the date is located, I am finding the selected date index from the array and dividing it by 7 because the grid has 7 columns. Given that each grid row height is 50, multiplying it by 50 gives the precise grid scroll value for the selected date's week.
	var monthProgress: CGFloat {
		let calendar = Calendar.autoupdatingCurrent
		if let index = selectedMonthDates.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
			return CGFloat(index / 7).rounded()
		}
		return 1.0
	}
	
	// Selected Year
	var year: String {
		return format("YYYY")
	}
	
	// View Heights & Paddings
	var calendarHeight: CGFloat {
		return calendarTitleViewHeight + weekLabelHeight + calendarGridHeight + safeArea.top + topPadding + bottomPadding
	}
	
	/// Each component of the calendar view will have a defined height, and this will be used later in the scroll animation.
	var calendarTitleViewHeight: CGFloat {
		return 75.0
	}
	
	var weekLabelHeight: CGFloat {
		return 30.0
	}
	
	var calendarGridHeight: CGFloat {
		/// As we know, each row in the grid will have a maximum height of 50, there is no spacing between each other, and each row will have 7 columns. Dividing the total by 7 and then multiplying by 50 will give the exact height of the grid view.
		return CGFloat(selectedMonthDates.count / 7) * 50
	}
	
	var horizontalPadding: CGFloat {
		return 15.0
	}
	
	var topPadding: CGFloat {
		return 15.0
	}
	
	var bottomPadding: CGFloat {
		return 5.0
	}
}

#Preview {
	CalendarScrollAnimationContentView()
}

// Custom Scroll Behaviour
/// With the help of iOS 17 scrollview updates, we can read where the scroll will end and change its position as per our needs.
struct CustomScrollBehaviour: ScrollTargetBehavior {
	var maxHeight: CGFloat
	func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
		if target.rect.minY < maxHeight {
			target.rect = .zero
		}
	}
}

// Date Extensions
extension Date {
	/// This will return the starting date of the current month.
	static var currentMonth: Date {
		let calendar = Calendar.autoupdatingCurrent
		guard let currentMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: .now)) else {
			return .now
		}
		return currentMonth
	}
}

extension View {
	// Extracting Days for the given month
	/// As stated before, the value of the month here is the starting date of the month.
	func extractDates(_ month: Date) -> [Day] {
		var days: [Day] = []
		let calendar = Calendar.autoupdatingCurrent
		let formatter = DateFormatter()
		formatter.dateFormat = "dd"
		
		guard let range = calendar.range(of: .day, in: .month, for: month)?
			.compactMap({ value -> Date? in
				/// Since the days range from 1 to 31, and since the date starts at 1, the date moves one day further, by applying -1 to the day, we can extract the correct date.
				return calendar.date(byAdding: .day, value: value - 1, to: month)
			})
		else {
			return days
		}
		
		/// As you can notice, the date is not correctly aligned with the weekday.
		/// In order to do that, we need to find the previous or next-month excess dates.
		/// The first thing I'm going to do is locate the first weekday. Using that weekday value, we can then determine how distant the first day is from Sunday.
		/// Finally, by looping it in reverse order, we can locate the prior month's date and mark it as an ignored day.
		let firstWeekDay = calendar.component(.weekday, from: range.first!)
		
		/// As I already told you, the first weekday value includes the first date of the month, so removing it will give the exact prior dates.
		for index in Array(0..<firstWeekDay - 1).reversed() {
			guard let date = calendar.date(byAdding: .day, value: -index - 1, to: range.first!) else { return days }
			let shortSymbol = formatter.string(from: date)
			days.append(Day(shortSymbol: shortSymbol, date: date, ignored: true))
		}
		
		range.forEach { date in
			let shortSymbol = formatter.string(from: date)
			days.append(Day(shortSymbol: shortSymbol, date: date))
		}
		
		/// So what's happening here is that first I will be finding the last-week value. Now we will have the last-week-day value. For example, if the last week day value is 5, then the excess dates to be added can be found by reducing by 7, thus we need to add 2 excess next month dates. By iterating it in normal order, we can add the excess next-month dates.
		let lastWeekDay = 7 - calendar.component(.weekday, from: range.last!)
		
		if lastWeekDay > 0 {
			for index in 0..<lastWeekDay {
				guard let date = calendar.date(byAdding: .day, value: index + 1, to: range.last!) else { return days }
				let shortSymbol = formatter.string(from: date)
				days.append(Day(shortSymbol: shortSymbol, date: date, ignored: true))
			}
		}
		
		return days
	}
}

struct Day: Identifiable {
	var id = UUID()
	var shortSymbol: String
	var date: Date
	// Previous/Next month excess Dates
	var ignored: Bool = false
}
