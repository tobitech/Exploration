import SwiftUI

struct ClockView: View {
	@State private var currentTime = Date()
	
	var body: some View {
		VStack(spacing: 16) {
			Text(timeString(from: currentTime))
				.font(.system(size: 48, weight: .bold, design: .monospaced))
				.padding()
			
			Text(dateString(from: currentTime))
				.font(.system(size: 24, weight: .medium, design: .default))
				.padding()
		}
		.onAppear {
			startClock()
		}
	}
	
	private func startClock() {
		// Schedule the timer to update the time every second
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			currentTime = Date()
		}
	}
	
	private func timeString(from date: Date) -> String {
		let formatter = DateFormatter()
		formatter.timeStyle = .medium
		formatter.dateStyle = .none
		return formatter.string(from: date)
	}
	
	private func dateString(from date: Date) -> String {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter.string(from: date)
	}
}

#Preview {
	ClockView()
}
