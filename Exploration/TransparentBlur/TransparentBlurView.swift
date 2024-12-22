import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
	var removeAllFilters: Bool = false
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		/// If you're going to keep the blur filter, then adjust the blur style for your needs, if you're going to completely ignore all filters, then it's not much of a concern.
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
		return view
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		/// As you can see, the Visual Effect View contains a backdrop colour, which is why it's not transparent.
		/// We're going to remove that filter and make the visual effect transparent.
		DispatchQueue.main.async {
			if let backdropLayer = uiView.layer.sublayers?.first {
				/// As you can see, these are the filters that cause the visual effect view to not be transparent, so what I'm going to do is remove either all filters or the expected blur filter based on my choice.
				// print(backdropLayer.filters)
				/// <UICABackdropLayer: 0x6000011872a0>
				/// Optional([luminanceCurveMap, colorSaturate, colorBrightness, gaussianBlur])
				if removeAllFilters {
					backdropLayer.filters = []
				} else {
					// Remove all except blur filters
					backdropLayer.filters?.removeAll(where: { filter in
						String(describing: filter) != "gaussianBlur"
					})
				}
			}
		}
	}
}

#Preview {
	TransparentBlurView(removeAllFilters: true)
		.padding()
}
