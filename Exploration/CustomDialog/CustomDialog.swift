import SwiftUI

struct CustomDialog: View {
	@Binding var isActive: Bool
	
	let title: String
	let message: String
	let buttonTitle: String
	let action: () -> Void
	
	@State private var offset: CGFloat = 1000
	
	var body: some View {
		ZStack {
			Color.black
				.opacity(0.1)
				.onTapGesture {
					close()
				}
			

			VStack {
				Text(title)
					.font(.title2)
					.bold()
					.padding()
				Text(message)
					.multilineTextAlignment(.center)
				
				Button {
					action()
					close()
				} label: {
					Text(buttonTitle)
						.font(.system(size: 16, weight: .bold))
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.padding()
						.background {
							RoundedRectangle(cornerRadius: 20)
								.fill(.red)
						}
						.padding()
				}
			}
			.padding()
			.background()
			.clipShape(.rect(cornerRadius: 20))
			.overlay(alignment: .topTrailing) {
				Button {
					close()
				} label: {
					Image(systemName: "xmark")
						.font(.title2)
				}
				.padding()
				.foregroundStyle(.primary)
			}
			.shadow(radius: 20)
			.padding(30)
			.offset(y: offset)
			.animation(.snappy, value: offset)
			.onAppear {
				withAnimation {
					offset = 0
				}
			}
		}
		.ignoresSafeArea()
	}
	
	func close() {
		withAnimation {
			offset = 1000
			isActive = false
		}
	}
}

#Preview {
	CustomDialogContentView()
}
