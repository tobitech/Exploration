import SwiftUI

struct InteractiveFloatingButtonContentView: View {
	@State private var colors: [Color] = [
		.red, .blue, .green, .yellow, .cyan, .brown, .purple, .indigo, .mint, .pink
	]
	
	var body: some View {
		NavigationStack {
			ScrollView(.vertical) {
				LazyVStack(spacing: 15) {
					ForEach(colors, id: \.self) { color in
						RoundedRectangle(cornerRadius: 15)
							.fill(color.gradient)
							.frame(height: 200)
					}
				}
				.padding(15)
			}
			.navigationTitle("Floating Button")
		}
	}
}

#Preview {
	InteractiveFloatingButtonContentView()
}
