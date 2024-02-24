// Source - https://youtu.be/aHtDymtNdSs?si=MlHkrv2vnJgwLpXe

import SwiftUI

struct ThemeSwitcherContentView: View {
	@State private var changeTheme: Bool = false
	@Environment(\.colorScheme) private var scheme
	@AppStorage("userTheme") private var userTheme: Theme = .systemDefault
	
	var body: some View {
		NavigationStack {
			List {
				Section("Appearance") {
					Button("Change Theme") {
						changeTheme.toggle()
					}
				}
			}
			.navigationTitle("Settings")
		}
		.preferredColorScheme(userTheme.colorScheme)
		.sheet(isPresented: $changeTheme, content: {
			ThemeChangeView(scheme: scheme)
				.presentationDetents([.height(410)])
				.presentationBackground(.clear)
		})
	}
}

#Preview {
	ThemeSwitcherContentView()
}
