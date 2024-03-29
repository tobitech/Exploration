import SwiftUI

struct CameraPickerView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIImagePickerController
	
	private let sourceType: UIImagePickerController.SourceType
	private let onImagePicked: (UIImage) -> Void
	
	@Environment(\.isPresented) private var isPresented
	@Environment(\.dismiss) private var dismiss
	
	public init(
		onImagePicked: @escaping (UIImage) -> Void,
		sourceType: UIImagePickerController.SourceType
	) {
		self.onImagePicked = onImagePicked
		self.sourceType = sourceType
	}
	
	public func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = self.sourceType
		picker.allowsEditing = true
		picker.delegate = context.coordinator
		return picker
	}
	
	public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(
			onDismiss: {
				if self.isPresented {
					self.dismiss()
				}
			},
			onImagePicked: self.onImagePicked
		)
	}
	
	final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		
		private let onDismiss: () -> Void
		private let onImagePicked: (UIImage) -> Void
		
		init(
			onDismiss: @escaping () -> Void,
			onImagePicked: @escaping (UIImage) -> Void
		) {
			self.onDismiss = onDismiss
			self.onImagePicked = onImagePicked
		}
		
		public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let image = info[.editedImage] as? UIImage {
				self.onImagePicked(image)
			}
			self.onDismiss()
		}
		
		public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			self.onDismiss()
		}
	}
}

