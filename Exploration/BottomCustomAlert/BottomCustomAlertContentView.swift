// Source - https://youtu.be/4EmyIMu9H5g?si=c4Sy46791uHGZ65f

import SwiftUI

struct BottomCustomAlertContentView: View {
	@Binding var show: Bool
	@State private var animateCircle = false
	var icon: Image = Image(systemName: "checkmark.circle.fill")
	var text: String = "Error"
	var gradientColor: Color = .red
	var circleAColor: Color = .green
	var details: String = "Your Message"
	var corner: CGFloat = 30
	
	var body: some View {
		VStack {
			Spacer()
			ZStack {
				RoundedRectangle(cornerRadius: corner)
					.frame(height: 300)
					.foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, gradientColor]), startPoint: .top, endPoint: .bottom))
					.opacity(0.4)
				ZStack {
					RoundedRectangle(cornerRadius: corner)
						.foregroundStyle(.white)
						.frame(height: 280)
						.shadow(color: .black.opacity(0.01), radius: 20, x: 0.0, y: 0.0)
						.shadow(color: .black.opacity(0.1), radius: 30, x: 0.0, y: 0.0)
					VStack(spacing: 20) {
						ZStack {
							Circle()
								.stroke(lineWidth: 2.0)
								.foregroundStyle(circleAColor)
								.frame(width: 105, height: 105)
								.scaleEffect(animateCircle ? 1.3 : 0.9)
								.opacity(animateCircle ? 1.3 : 0.9)
								.animation(.easeInOut(duration: 2).delay(1).repeatForever(autoreverses: false), value: animateCircle)
							Circle()
								.stroke(lineWidth: 2.0)
								.foregroundStyle(circleAColor)
								.frame(width: 105, height: 105)
								.scaleEffect(animateCircle ? 1.3 : 0.9)
								.opacity(animateCircle ? 1.3 : 0.9)
								.animation(.easeInOut(duration: 2).delay(1.5).repeatForever(autoreverses: false), value: animateCircle)
								.onAppear(perform: {
									animateCircle.toggle()
								})
							icon
								.resizable()
								.frame(width: 100, height: 100, alignment: .center)
								.foregroundStyle(circleAColor)
						}
						Text(text)
							.bold()
							.font(.system(size: 30))
						Text(details)
							.foregroundStyle(.secondary)
					}
				}
				.padding(.horizontal, 10)
			}
		}
		.ignoresSafeArea()
	}
}

#Preview {
	BottomCustomAlertContentView(show: .constant(true))
}
