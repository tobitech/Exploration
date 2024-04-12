import SwiftUI

struct CropImageHomeView: View {
	// View Properties
	@State private var showPicker: Bool = false
	@State private var croppedImage: UIImage?
	
	var body: some View {
		NavigationStack {
			VStack {
				if let croppedImage {
					Image(uiImage: croppedImage)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 300, height: 400)
				} else {
					Text("No image selected")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			.navigationTitle("Crop Image Picker")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button(action: { showPicker.toggle() }, label: {
						Image(systemName: "photo.on.rectangle.angled")
							.font(.callout)
					})
				}
			}
			.cropImagePicker(options: [.circle, .rectangle, .square, .custom(.init(width: 200, height: 200))], show: $showPicker, croppedImage: $croppedImage)
		}
	}
}

#Preview {
	CropImageContentView()
}
