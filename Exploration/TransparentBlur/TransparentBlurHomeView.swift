import SwiftUI

struct TransparentBlurHomeView: View {
	// View Properties
	@State private var activePic: String = "Pic 1"
	@State private var blurType: BlurType = .freeStyle
	
	var body: some View {
		GeometryReader {
			let safeArea = $0.safeAreaInsets
			
			ScrollView(.vertical) {
				VStack(spacing: 15) {
					/// You can simply use transparent blur like this, but I needed a custom blur effect that didn't clip at the bottom, so what l'm going to do is remove all default blur filters from the Visual Effect view and use SwiftUl blur to make it more subtle at the bottom. It's obviously your choice whether to use default blur or custom blur.
					/// As you can see, the blur effect is not clipping at the bottom, but one thing is that the edges are fading out. We can use the opaque option, but it will clip the blur like the default ones, so here's a trick: Simply extend the view size sufficiently to match your blur amount, and you're good to go.
					TransparentBlurView(removeAllFilters: true)
					/// As I said earlier, opaque will clip the blur effect, so I will make use of this when I actually need a clipped blur effect.
						.blur(radius: 15, opaque: blurType == .clipped)
						.padding([.horizontal, .top], -30)
						.frame(height: 140 + safeArea.top)
					/// Available in iOS 17+ to read the scroll offsets directly from SwiftUI views.
						.visualEffect { view, proxy in
							view
								.offset(y: (proxy.bounds(of: .scrollView)?.minY ?? 0))
						}
					/// Placing it above all the views.
						.zIndex(1000)
					
					VStack(alignment: .leading, spacing: 10) {
						GeometryReader {
							let size = $0.size
							Image(activePic)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: size.width, height: size.height)
								.clipShape(.rect(cornerRadius: 25))
						}
						.frame(height: 500)
						
						Text("Blur Type")
							.font(.caption)
							.foregroundStyle(.secondary)
							.padding(.top)
						
						Picker("", selection: $blurType) {
							ForEach(BlurType.allCases, id: \.self) {
								Text($0.rawValue)
									.tag($0)
							}
						}
						.pickerStyle(.segmented)
					}
					.padding()
					.padding(.bottom, 500)
				}
			}
			.scrollIndicators(.hidden)
			.ignoresSafeArea(.container, edges: .top)
		}
	}
}

#Preview {
	TransparentBlurContentView()
		// .preferredColorScheme(.dark)
}

// Blur State
enum BlurType: String, CaseIterable {
	case clipped = "Clipped"
	case freeStyle = "Free Style"
}
