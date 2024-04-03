import SwiftUI

struct ReportCardView: View {
	var gradientBackground: LinearGradient {
		LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
	}
	
	var body: some View {
		HStack {
			Text("Weekly Report")
				.font(.title)
				.foregroundStyle(.white)
		}
		.frame(maxWidth: .infinity, alignment: .top)
		.frame(height: 120)
		.background(gradientBackground.opacity(0.8), in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
