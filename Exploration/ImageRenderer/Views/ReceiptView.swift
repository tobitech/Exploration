import SwiftUI

struct ReceiptView: View {
	var body: some View {
		VStack {
			VStack (spacing: 10) {
				Image(systemName: "checkmark.circle.fill")
					.font(.title.bold())
					.foregroundStyle(.green)
				Text("Payment Received")
					.fontWeight(.black)
					.foregroundStyle(.green)
				Text("$150.698")
					.font(.largeTitle.bold())
				
				VStack(spacing: 15) {
					Image("avi2")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 45, height: 45)
						.clipShape(Circle())
						.padding(10)
						.background {
							Circle()
								.fill(.white.shadow(.drop(color: .black.opacity(0.05), radius: 5)))
						}
					Text("The Anaheim Hotel")
						.font(.title3.bold())
						.padding(.bottom, 12)
					
					LabeledContent {
						Text("$150.698")
							.fontWeight(.semibold)
							.foregroundStyle(.primary)
					} label: {
						Text("Total Bill")
							.foregroundStyle(.secondary)
					}
					LabeledContent {
						Text("$0.00")
							.fontWeight(.semibold)
							.foregroundStyle(.primary)
					} label: {
						Text("Total Tax")
							.foregroundStyle(.secondary)
					}
					Label {
						Text("You Got 240 Points")
							.font(.system(size: 14, weight: .semibold))
							.foregroundStyle(.purple)
					} icon: {
						Image(systemName: "gift")
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.vertical, 8)
					.padding(.horizontal)
					.background {
						RoundedRectangle(cornerRadius: 10, style: .continuous)
							.fill(.purple.opacity(0.08))
					}

				}
				.padding()
				.background {
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.fill(
							.white.shadow(.drop(color: .black.opacity(0.05), radius: 10, x: 5, y: 5)).shadow(.drop(color: .black.opacity(0.05), radius: 35, x: -5, y: -5))
						)
						.padding(.top, 55)
				}
				
				Text("Transaction Details")
					.font(.title2.bold())
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.top)
				
				VStack(spacing: 16) {
					LabeledContent {
						Text("Apple")
							.foregroundStyle(.primary)
					} label: {
						Text("Payment Method")
							.foregroundStyle(.secondary)
					}
					.opacity(0.7)
					LabeledContent {
						Text("In Progress")
							.foregroundStyle(.primary)
					} label: {
						Text("Status")
							.foregroundStyle(.secondary)
					}
					.opacity(0.7)
					LabeledContent {
						Text("25 Jun, 2022")
							.foregroundStyle(.primary)
					} label: {
						Text("Transaction Date")
							.foregroundStyle(.secondary)
					}
					.opacity(0.7)
					LabeledContent {
						Text("9:25 PM")
							.foregroundStyle(.primary)
					} label: {
						Text("Transaction Time")
							.foregroundStyle(.secondary)
					}
					.opacity(0.7)

				}
				.padding(.top)
			}
			.padding()
			.background {
				Color.white
					.ignoresSafeArea()
			}
			
			LabeledContent {
				Text("$150.698")
					.foregroundStyle(.primary)
			} label: {
				Text("Total Payment")
					.foregroundStyle(.secondary)
			}
			.opacity(0.7)
			.padding()
			.background {
				Color.white
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background {
			Color.gray.opacity(0.2)
				.ignoresSafeArea()
		}
	}
}

#Preview {
	ImageRendererContentView()
}
