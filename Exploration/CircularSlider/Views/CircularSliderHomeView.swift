import SwiftUI

// TODO: Add Haptics as user scrolls to a particular item in the carousel similar to Instagram stories effects.
struct CircularSliderHomeView: View {
	// View Properties
	@State private var pickerType: TripPicker = .normal
	@State private var activeID: Int?
	
	var body: some View {
		VStack {
			Picker("", selection: $pickerType) {
				ForEach(TripPicker.allCases, id: \.self) {
					Text($0.rawValue)
						.tag($0)
				}
			}
			.pickerStyle(.segmented)
			.padding()
			
			Spacer(minLength: 0)
			
			GeometryReader {
				let size = $0.size
				// to start the carousel slider at the centre
				let padding = (size.width - 70) / 2
				
				// Circular Slider
				ScrollView(.horizontal) {
					HStack(spacing: 35) {
						ForEach(1...8, id: \.self) { index in
							Image("Pic \(index)")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 70, height: 70)
								.clipShape(Circle())
								// Shadow
								.shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
								.visualEffect { view, proxy in
									view
										.offset(y: offset(proxy))
										.offset(y: scale(proxy) * 15)
								}
								.scrollTransition(.interactive, axis: .horizontal) { view, phase in
									/// By using the activelD, we can scale the centre view with the help of the scrollTransitions API.
									view
//										.offset(y: phase.isIdentity && activeID == index ? 15 : 0)
										.scaleEffect(phase.isIdentity && activeID == index && pickerType == .scaled ? 1.5 : 1, anchor: .bottom)
								}
						}
					}
					.frame(height: size.height)
					.offset(y: -30)
					/// IF WE USE PADDING TO MOVE THE CAROUSEL SLIDER, THEN THE GEOMETRY PROXY WILL NOT START FROM ZERO. TO SOLVE THIS, IOS 17 HAS A NEW MODIFIER THAT WILL ADD PADDING TO ITS CONTENT. BY DOING THIS, WE CAN READ GEOMETRY PROXY VALUES FROM ZERO.
					// .padding(.horizontal, padding)
					.scrollTargetLayout()
				}
				.background {
					if pickerType == .normal {
						Circle()
							.fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
							.frame(width: 85, height: 85)
						/// AS YOU CAN SEE, WE PUSHED OUR VIEW TO THE TOP BY AROUND 30 PIXELS, BUT THE BACKGROUND IS NOT FIXED AT ITS CENTRE POINT. THE REASON IS THAT WE ADJUSTED THE CENTRE VIEW BY AROUND 15 PIXELS TO MAKE IT LOOK LIKE A CIRCLE, THUS -30 + 15 = -15.
							.offset(y: -15)
					}
				}
				.safeAreaPadding(.horizontal, padding)
				.scrollIndicators(.hidden)
				// Snapping
				.scrollTargetBehavior(.viewAligned)
				.scrollPosition(id: $activeID)
				.frame(height: size.height)
			}
			/// The height is 200; why?
			/// Since the scroll view height is 70, the view will move 30 pixels up and down, making the total movement 60 pixels. Since the scroll view height is 70 pixels, the view needs a space of 70 pixels to move lower. We will get a value of 200 when we add this, and I'm also changing the scroll content in its centre by setting HStack to -30 pixels.
			.frame(height: 200)
			// .background(.red)
		}
		.ignoresSafeArea(.container, edges: .bottom)
	}
	
	// Circular Slider View Offset
	/// As you can see, we almost achieved a circular slider here, so what's happening here is that when the minX goes beyond zero, the view will go downward, and vice versa.
	/// EG: Progress = -1.2
	/// Now the offset will be:
	/// Offset = (-1.2) * -30 = 36 /View Goes down)
	func offset(_ proxy: GeometryProxy) -> CGFloat {
		// View Width
		let progress = progress(proxy)
		// Simply moving view up/down based on progress
		return progress < 0 ? progress * -30 : progress * 30
	}
	
	/// Using scroll progress approach rather than scroll transition
	/// Basically, It will only provide a range of 1-0 when the view reaches its centre, allowing us to use this range to change the centre view offset as necessary.
	func scale(_ proxy: GeometryProxy) -> CGFloat {
		let progress = min(max(progress(proxy), -1), 1)
		return progress < 0 ? 1 + progress : 1 - progress
	}
	
	func progress(_ proxy: GeometryProxy) -> CGFloat {
		let viewWidth = proxy.size.width
		let minX = (proxy.bounds(of: .scrollView)?.minX ?? 0)
		let progress = minX / viewWidth
		return progress
	}
}

#Preview {
	CircularSliderContentView()
}

// Slider Type
enum TripPicker: String, CaseIterable {
	case scaled = "Scaled"
	case normal = "Normal"
}
