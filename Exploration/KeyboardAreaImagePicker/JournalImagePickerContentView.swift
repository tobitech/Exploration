//
//  JournalImagePickerContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 20/02/2025.
//  Source - https://youtu.be/XKqQLIGKOzI?si=Pl6TdI0Jolg4RshQ

import PhotosUI
import SwiftUI

struct JournalImagePickerContentView: View {
	@State private var showPicker: Bool = false
	@State private var selectedImage: UIImage?
	@State private var textInput: String = ""
	@State private var pushIconsUp: Bool = false

	@FocusState private var isTextFieldFocused: Bool

	var body: some View {
		ZStack {
			if let uiImage = selectedImage {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(width: 200, height: 200)
					.clipShape(.rect(cornerRadius: 24))
			} else {
				Text("No image selected")
					.foregroundStyle(.secondary)
			}
		}
		.offset(y: 50)
		VStack(spacing: 0) {
			TextField("Type something...", text: $textInput)
				.padding()
				.focused($isTextFieldFocused)
				.submitLabel(.done)
				.background(.secondary, in: .rect(cornerRadius: 12))
				.frame(height: 55)
				.padding(.horizontal, 5)
				.onChange(of: isTextFieldFocused) { oldValue, newValue in
					if !oldValue && newValue {
						withAnimation {
							pushIconsUp = true
						}
					}
				}
				.onSubmit {
					withAnimation {
						pushIconsUp = false
						isTextFieldFocused = false
					}
				}
			
			HStack {
				Button(action: {}, label: { Image(systemName: "textformat.size") })
				Button(action: {}, label: { Image(systemName: "wand.and.stars") })
				Button(action: { showPicker = true }, label: { Image(systemName: "photo.on.rectangle.angled") })
				Button(action: {}, label: { Image(systemName: "camera") })
				Button(action: {}, label: { Image(systemName: "keyboard") })
				Button(action: {}, label: { Image(systemName: "paperplane") })
				Button(action: {}, label: { Image(systemName: "tree") })
			}
			.font(.system(size: 22))
			.padding()
			.frame(maxWidth: .infinity)
			.background(.secondary)
			.foregroundStyle(.primary)
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
		.offset(y: pushIconsUp ? -UIScreen.main.bounds.height * 0.35 : 0)
		.sheet(isPresented: $showPicker) {
			ImagePicker(selectedImage: $selectedImage)
				.presentationDetents([.fraction(0.4), .large])
				.onAppear {
					withAnimation {
						pushIconsUp = true
						isTextFieldFocused = false
					}
				}
				.onDisappear {
					withAnimation(.easeInOut) {
						isTextFieldFocused = true
					}
				}
		}
		.ignoresSafeArea(.keyboard)
	}
}

#Preview {
	JournalImagePickerContentView()
}

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var selectedImage: UIImage?

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIViewController(context: Context) -> UIViewController {
		var configuration = PHPickerConfiguration()
		configuration.filter = .images
		configuration.selectionLimit = 1
		
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(
		_ uiViewController: UIViewController, context: Context
	) {
	}
	
	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: ImagePicker
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)
			
			guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
				return
			}
			
			provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
				guard let uiImage = image as? UIImage else { return }
				DispatchQueue.main.async {
					self?.parent.selectedImage = uiImage
				}
			}
		}
	}
}
