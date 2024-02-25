import SwiftUI

struct AlertView<Content: View>: View {
	@Binding var config: AlertConfig
	// View Tag
	var tag: Int
	@ViewBuilder var content: () -> Content
	var body: some View {
		GeometryReader { geometry in
			Color.red
		}
	}
}
