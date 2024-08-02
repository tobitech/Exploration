import SwiftUI

struct EthereumBalanceView: View {
	@State private var isLoading = true
	@State private var isAnimating = false
	@State private var offset: CGFloat = 120
	
	var body: some View {
		VStack {
			ZStack {
				VStack(alignment: .leading, spacing: 0) {
					SkeletonItem()
						.opacity(0.5)
					SkeletonItem()
						.opacity(0.3)
					SkeletonItem()
						.opacity(0.2)
				}
				if !isLoading {
					VStack(spacing: 15) {
						Text("There is nothing here, yet")
							.fontWeight(.medium)
						Text("Deposit tokens to your address or buy Ethereum to start using your wallet.")
							.fontWeight(.medium)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
						Button(action: {}, label: {
							Text("Receive")
								.font(.title3.weight(.semibold))
								.padding()
								.frame(maxWidth: .infinity)
								.background(.quinary, in: .rect(cornerRadius: 30))
						})
						.buttonStyle(.plain)
						.scaleEffect(isAnimating ? 0.8 : 1)
						.animation(.snappy(duration: 1), value: isAnimating)
						Text("Learn more about tokens")
							.font(.subheadline)
							.foregroundStyle(.tertiary)
							.opacity(isAnimating ? 0 : 1)
							.animation(.easeInOut(duration: 1.2), value: isAnimating)
					}
					.padding(.horizontal)
					.offset(y: isLoading ? 80 : 120)
					.opacity(isLoading ? 0 : 1)
					.transition(.move(edge: .bottom))
					.animation(.easeInOut(duration: 0.3), value: isAnimating)
				 }
			}
			.padding(10)
			Spacer()
			Button(action: {
				runAnimation()
			}, label: {
				Text("Start")
			})
			.buttonStyle(.borderedProminent)
			.tint(.primary)
		}
		.fullScreenCover(isPresented: .constant(true), content: {
			
		})
	}
	
	func runAnimation() {
		withAnimation {
			isLoading.toggle()
			isAnimating.toggle()
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			withAnimation {
				isAnimating.toggle()
			}
		}
	}
	
	@ViewBuilder
	func SkeletonItem() -> some View {
		HStack(alignment: .top) {
			Circle()
				.fill(.gray.opacity(0.1))
				.frame(width: 60, height: 60)
			
			VStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 10)
					.fill(.gray.opacity(0.1))
					.frame(width: 150, height: 20)
				RoundedRectangle(cornerRadius: 10)
					.fill(.gray.opacity(0.1))
					.frame(width: 100, height: 15)
			}
			
			Spacer()
			
			RoundedRectangle(cornerRadius: 10)
				.fill(.gray.opacity(0.1))
				.frame(width: 40, height: 20)
		}
		.padding(10)
	}
}

#Preview {
	EthereumBalanceView()
}
