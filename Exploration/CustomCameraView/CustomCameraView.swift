import SwiftUI
import AVFoundation

// Camera Model
class CameraModel: NSObject, ObservableObject {
	@Published var isTaken: Bool = false
	@Published var session = AVCaptureSession()
	@Published var alert: Bool = false
	// Since we're going to read picture data.
	@Published var output = AVCapturePhotoOutput()
	@Published var preview = AVCaptureVideoPreviewLayer()
	// Pic data
	@Published var isSaved: Bool = false
	@Published var picData = Data(count: 0)
	
	func check() {
		// first check for camera permission
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			// setting up capture session
			setup()
			return
		case .notDetermined:
			// requesting for permission
			AVCaptureDevice.requestAccess(for: .video) { status in
				if status {
					self.setup()
				}
			}
		case .denied:
			self.alert.toggle()
			return
		default:
			return
		}
	}
	
	func setup() {
		// setting up camera
		do {
			// setting configs
			self.session.beginConfiguration()
			guard let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return }
			let input = try AVCaptureDeviceInput(device: device)
			
			// checking and adding input to session
			if self.session.canAddInput(input) {
				self.session.addInput(input)
			}
			
			// same for output
			if self.session.canAddOutput(output) {
				self.session.addOutput(output)
			}
			self.session.commitConfiguration()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	// Take and Retake functions.
	func takePic() {
		DispatchQueue.global(qos: .background).async {
			self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
			// There is a problem here where only when I set a break point this take pic will work.
			self.session.stopRunning()
			
			DispatchQueue.main.async {
				withAnimation {
					self.isTaken.toggle()
				}
			}
		}
	}
	
	func reTake() {
		DispatchQueue.global(qos: .background).async {
			self.session.startRunning()
			DispatchQueue.main.async {
				withAnimation { self.isTaken.toggle() }
				// clearing
				self.isSaved = false
			}
		}
	}
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if error != nil {
			return
		}
		
		print("photo taken")
		guard let imageData = photo.fileDataRepresentation() else { return }
		self.picData = imageData
	}
	
	func savePic() {
		guard let image = UIImage(data: self.picData) else { return }
		// saving image
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		self.isSaved = true
		print("saved successfully")
	}
}

struct CustomCameraView: View {
	@StateObject var camera = CameraModel()
	
	var body: some View {
		ZStack {
			// This is going to be the camera preview.
			// Color.black
			CameraPreview(camera: camera)
				.ignoresSafeArea(.all, edges: .all)
			VStack {
				if camera.isTaken {
					HStack {
						Spacer()
						Button { camera.reTake() } label: {
							Image(systemName: "arrow.triangle.2.circlepath.camera")
								.foregroundStyle(.black)
								.padding()
								.background(.white)
								.clipShape(.circle)
						}
						.buttonStyle(.plain)
						.padding(.trailing, 10)
					}
				}
				
				Spacer()
				HStack {
					// if taken, show save and again take button
					if camera.isTaken {
						Button {
							if !camera.isSaved {
								camera.savePic()
							}
						} label: {
							Text(camera.isSaved ? "Saved" : "Save")
								.foregroundStyle(.black)
								.fontWeight(.semibold)
								.padding(.vertical, 10)
								.padding(.horizontal, 20)
								.background(.white)
								.clipShape(.capsule)
						}
						.buttonStyle(.plain)
						.padding(.leading)
						Spacer()
					} else {
						CameraShutter()
					}
				}
				.frame(height: 75)
			}
			.onAppear {
				self.camera.check()
			}
		}
	}
	
	// Shutter
	@ViewBuilder
	func CameraShutter() -> some View {
		Button { camera.takePic() } label: {
			ZStack {
				Circle()
					.fill(.white)
					.frame(width: 65, height: 65)
				Circle()
					.stroke(.white, lineWidth: 2.0)
					.frame(width: 75, height: 75)
			}
		}
	}
}

#Preview {
	CustomCameraContentView()
}

struct CameraPreview: UIViewRepresentable {
	@ObservedObject var camera: CameraModel
	
	func makeUIView(context: Context) -> UIView {
		let view  = UIView(frame: UIScreen.main.bounds)
		camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
		camera.preview.frame = view.frame
		camera.preview.videoGravity = .resizeAspectFill
		view.layer.addSublayer(camera.preview)
		
		// starting session
		camera.session.startRunning()
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}
