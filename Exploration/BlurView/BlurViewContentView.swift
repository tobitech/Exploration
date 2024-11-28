import SwiftUI

struct BlurView: UIViewRepresentable {
	var style: UIBlurEffect.Style = .systemMaterial

	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}

struct BlurViewContentView: View {
	var gradientBackground: LinearGradient {
		LinearGradient(
			colors: [.yellow, .blue], startPoint: .topLeading,
			endPoint: .bottomTrailing)
	}
	
	var body: some View {
		ZStack {
//			Image(.pic8)
//				.resizable()
//				.scaledToFill()
//				.edgesIgnoringSafeArea(.all)
//				.blur(radius: 45)
			
			Rectangle()
				.fill(gradientBackground)
				.frame(width: 250, height: 500)
				.clipShape(.rect(cornerRadius: 30))
				.blur(radius: 45)
			

			VStack {
				Spacer()
				Text("Hello, World!")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
					.padding()
					.cornerRadius(10)
				Spacer()
			}
		}
	}
}

#Preview {
	BlurViewContentView()
}
