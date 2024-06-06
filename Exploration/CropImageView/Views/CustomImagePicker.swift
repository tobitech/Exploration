import PhotosUI // For Native Image Picker
import SwiftUI

// Someone's comment on YouTube
/*
This was great help!
I had issues with the offset after scaling, when the image exceeded the bounds of the view
I updated the logic for handling the bounds to something like this, and proved to be an improvment

GeometryReader { proxy in
		let frame = proxy.frame(in: .named("cropView"))
		Color.clear.onChange(of: isInteracting) { isDragging in
				withAnimation(.easeOut) {
						let horizontalOverflow = (frame.width - size.width) / 2
						offset.width = min(horizontalOverflow, max(-horizontalOverflow, offset.width))

						let verticalOverflow = (frame.height - size.height) / 2
						offset.height = min(verticalOverflow, max(-verticalOverflow, offset.height))
				}
				if !isDragging {
						previousOffset = offset
				}
		}
}
 */

// View Extensions
extension View {
	@ViewBuilder
	func cropImagePicker(
		options: [Crop],
		show: Binding<Bool>,
		croppedImage: Binding<UIImage?>
	) -> some View {
		CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
			self
		}
	}
	
	// For simplifying use of frame with CGSize.
	@ViewBuilder
	func frame(_ size: CGSize) -> some View {
		self
			.frame(width: size.width, height: size.height)
	}
	
	// Haptic Feedback
	func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	}
}

fileprivate struct CustomImagePicker<Content: View>: View {
	var content: Content
	
	var options: [Crop]
	@Binding var show: Bool
	@Binding var croppedImage: UIImage?
	
	init(
		options: [Crop],
		show: Binding<Bool>,
		croppedImage: Binding<UIImage?>,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.options = options
		self._show = show
		self._croppedImage = croppedImage
		self.content = content()
	}
	
	// View Properties
	@State private var photosItem: PhotosPickerItem?
	@State private var selectedImage: UIImage?
	@State private var showDialog: Bool = false
	@State private var selectedCropType: Crop = .circle
	@State private var showCropView: Bool = false
	
	var body: some View {
		content
			.photosPicker(isPresented: $show, selection: $photosItem)
			.onChange(of: photosItem) { _, newValue in
				// Extract UIImage from Photos Item
				if let newValue {
					Task {
						if let imageData = try? await newValue.loadTransferable(type: Data.self), 
								let image = UIImage(data: imageData) {
							// UI must be updated on the main thread.
							await MainActor.run {
								selectedImage = image
								showDialog.toggle()
							}
						}
					}
				}
			}
			.confirmationDialog("", isPresented: $showDialog) {
				// Displaying all the options
				ForEach(options.indices, id: \.self) { index in
					Button(options[index].name) {
						selectedCropType = options[index]
						showCropView.toggle()
					}
				}
			}
			.fullScreenCover(isPresented: $showCropView) {
				// Whenever full screen cover is closed, set selectedImage to nil.
				selectedImage = nil
			} content: {
				CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
					if let croppedImage {
						self.croppedImage = croppedImage
					}
				}
			}
	}
}

struct CropView: View {
	var crop: Crop
	var image: UIImage?
	// This callback will give the cropped image and result status when checkmark button is pressed.
	var onCrop: (UIImage?, Bool) -> Void
	
	// View Properties
	@Environment(\.dismiss) private var dismiss
	// Gesture Properties
	@State private var scale: CGFloat = 1
	@State private var lastScale: CGFloat = 0
	@State private var offset: CGSize = .zero
	@State private var lastStoredOffset: CGSize = .zero
	@GestureState private var isInteracting: Bool = false
	
	var body: some View {
		NavigationStack {
			ImageView()
				.navigationTitle("Crop View")
				.navigationBarTitleDisplayMode(.inline)
				.toolbarBackground(.visible, for: .navigationBar)
				.toolbarBackground(Color.black, for: .navigationBar)
				.toolbarColorScheme(.dark, for: .navigationBar)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background {
					Color.black
						.ignoresSafeArea()
				}
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button(action: {
							// Generating Cropped Image
							// Converting View to Image (Native iOS 16+)
							let renderer = ImageRenderer(content: ImageView(true))
							renderer.proposedSize = .init(crop.size)
							if let image = renderer.uiImage {
								onCrop(image, true)
							} else {
								onCrop(nil, false)
							}
							dismiss()
						}, label: {
							Image(systemName: "checkmark")
								.font(.callout)
								.fontWeight(.semibold)
						})
						.buttonStyle(.plain)
					}
					ToolbarItem(placement: .topBarLeading) {
						Button(action: { dismiss() }, label: {
							Image(systemName: "xmark")
								.font(.callout)
								.fontWeight(.semibold)
						})
						.buttonStyle(.plain)
					}
				}
		}
	}
	
	// Image View
	@ViewBuilder
	func ImageView(_ hideGrids: Bool = false) -> some View {
		let cropSize = crop.size
		GeometryReader {
			let size = $0.size
			if let image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.overlay {
						GeometryReader { proxy in
							let rect = proxy.frame(in: .named("CROPVIEW"))
							/// So since we used overlay before the .frame() modifier, it will give the image natural size, thus helping us find the edges (top, left, bottom, right.
							/// CoordinateSpace ensures that it will calculate its rect from the given view and not from the global view.
							
							Color.clear
							/// We are using this instead of onEnded from the gesture because onEnded() doesn't always get called but updating() is called whenever a gesture is updated.
								.onChange(of: isInteracting) { _, newValue in
									// True - Dragging
									// False - Stopped Dragging
									/// With the help of GeometryReader we can now read the minX,Y and maxX,Y of the image
									
									if !newValue {
										// this was outside the if !newValue statement before.
										withAnimation(.easeInOut(duration: 0.2)) {
											if rect.minX > 0 {
												// Resetting to last location.
												/// So consider that minX is above zero, like 45, and if we set offset to 0, then it will reset to its initial state, so reducing the minX from the offset will set the image to its start.
												/// Example: minX = 45 width of offset = 145; As a result, we must remove the excess 45 by doing offset. width - minX.
												offset.width = (offset.width - rect.minX)
												haptics(.medium)
											}
											if rect.minY > 0 {
												offset.height = (offset.height - rect.minY)
												haptics(.medium)
											}
											
											// Doing the same for maxX,Y
											if rect.maxX < size.width {
												/// So, since maxX is less than the image's width, say 230, and the image's width is 300, we need to reset at its extent; let's see how.
												/// Example: offset.width = -110, image width = 300, minX = -150, maxX = 230; Thus, doing (imageWidth - maxX) + offset. width will give the extend's offset, but instead of doing this, we simply did (minX - offset.width). Essentially, we will get the same result. (300 - 230) - 110 = -40 || (-150 + 110) = -40
												offset.width = (rect.minX - offset.width)
												haptics(.medium)
											}
											
											if rect.maxY < size.height {
												offset.height = (rect.minY - offset.height)
												haptics(.medium)
											}
										}
										// Storing LastOffset
										lastStoredOffset = offset
									}
								}
						}
					}
					.frame(size)
			}
		}
		.scaleEffect(scale)
		.offset(offset)
		.overlay {
			if !hideGrids {
				Grids()
			}
		}
		.coordinateSpace(.named("CROPVIEW"))
		.gesture(
			DragGesture()
				.updating($isInteracting, body: { _, out, _ in
					out = true
				})
				.onChanged({ value in
					let translation = value.translation
					offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
				})
		)
		.gesture(
			MagnifyGesture() // iOS 16 - MagnificationGesture()
				.updating($isInteracting, body: { _, out, _ in
					out = true
				})
				.onChanged({ value in
					// iOS 16 - let updatedScale = value + lastScale
					let updatedScale = value.magnification + lastScale
					scale = (updatedScale < 1 ? 1 : updatedScale)
				})
				.onEnded({ value in
					withAnimation(.easeInOut(duration: 0.2)) {
						if scale < 1 {
							scale = 1
							lastScale = 0
						} else {
							lastScale = scale - 1
						}
					}
				})
		)
		.frame(cropSize)
		.cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
		//.clipShape(crop == Crop.circle ? Circle() : Rectangle())
	}
	
	// Grids
	@ViewBuilder
	func Grids() -> some View {
		ZStack {
			HStack {
				ForEach(1...5, id: \.self) { _ in
					Rectangle()
						.fill(.white.opacity(0.7))
						.frame(width: 1)
						.frame(maxWidth: .infinity)
				}
			}
			VStack {
				ForEach(1...8, id: \.self) { _ in
					Rectangle()
						.fill(.white.opacity(0.7))
						.frame(height: 1)
						.frame(maxHeight: .infinity)
				}
			}
		}
	}
}

#Preview {
	CropView(crop: .square, image: UIImage(named: "Pic 1")) { _, _ in
		
	}
}
