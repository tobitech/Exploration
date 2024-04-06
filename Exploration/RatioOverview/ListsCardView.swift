import SwiftUI

struct ListsCardView: View {
	@State private var showItems: Bool = true
	
	var body: some View {
		VStack(alignment: .leading) {
			// Label("Planned list", systemImage: "list.bullet.clipboard")
			HStack {
				Text("Planned list")
					.font(.footnote)
					.fontWeight(.medium)
					// .textCase(.uppercase)
					.foregroundStyle(.secondary)
				Spacer()
				Text("3")
					.fontWeight(.semibold)
			}
			if showItems {
				ForEach(0..<3, id: \.self) { index in
					HStack {
						Circle()
							.stroke(.secondary.opacity(0.3), lineWidth: 2.0)
							.frame(width: 18, height: 18)
						Text("Prepare Pizza")
							.font(.subheadline)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, 5)
				}
			} else {
				VStack(alignment: .leading, spacing: 0) {
					Text("12")
						.font(.title)
						.padding(.top, 5)
					Text("items")
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				Spacer()
				HStack(alignment: .bottom) {
					Text("Completed")
						.font(.footnote)
						.fontWeight(.medium)
						.foregroundStyle(.secondary)
					Spacer()
					Text("8")
						.font(.subheadline)
						.fontWeight(.medium)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.frame(height: 130)
		.padding()
		.background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 20))
	}
}

#Preview {
	RatioContentView()
}
