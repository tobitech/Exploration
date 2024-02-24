import SwiftUI

struct ErrorView: View {
	let error: Error
	
	var body: some View {
		print(error)
		return Text("❌ **Error**").font(.system(size: 60))
	}
}
