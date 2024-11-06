import SwiftUI

struct ColorFromImage: View {
	@State private var gradient: AnyGradient = Color.clear.gradient
	
	var body: some View {
		ScrollView {
			VStack {
				HStack {
					Image(.pic13)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipShape(.rect(cornerRadius: 20))
					Image(.pic13)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipShape(.rect(cornerRadius: 20))
				}
				ZStack(alignment: .bottom) {
					RoundedRectangle(cornerRadius: 20)
						.fill(.mint)
						.fill(LinearGradient(colors: [.black, .mint], startPoint: .bottom, endPoint: .top).opacity(0.8))
					VStack(alignment: .leading) {
						Text(".linear")
							.font(.title)
							.foregroundStyle(.white)
					}
					.padding()
					.frame(maxWidth: .infinity, alignment: .leading)
				}
				.frame(height: 200)
				HStack {
					ZStack(alignment: .bottom) {
						RoundedRectangle(cornerRadius: 20)
							.fill(.mint)
							.fill(Gradient(from: .yellow, to: .blue, with: .easeIn))
						VStack(alignment: .leading) {
							Text(".easeIn")
								.font(.title)
								.foregroundStyle(.white)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
					}
					ZStack(alignment: .bottom) {
						RoundedRectangle(cornerRadius: 20)
							.fill(.mint)
							.fill(Gradient(from: .yellow, to: .blue, with: .easeOut))
						VStack(alignment: .leading) {
							Text(".easeOut")
								.font(.title)
								.foregroundStyle(.white)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.frame(height: 200)
				HStack {
					ZStack(alignment: .bottom) {
						RoundedRectangle(cornerRadius: 20)
							.fill(.mint)
							.fill(Gradient(from: .yellow, to: .blue, with: .easeInOut))
						VStack(alignment: .leading) {
							Text(".easeInOut")
								.font(.title)
								.foregroundStyle(.white)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
					}
					ZStack(alignment: .bottom) {
						RoundedRectangle(cornerRadius: 20)
							.fill(.mint)
							.fill(Gradient(from: .yellow, to: .blue, with: .linear))
						VStack(alignment: .leading) {
							Text(".linear")
								.font(.title)
								.foregroundStyle(.white)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.frame(height: 200)
			}
			.padding()
			.onAppear {
				gradient = Color(UIImage(named: "Pic 13")?.prominentColor ?? .clear).gradient
			}
		}
	}
}

#Preview {
	ColorFromImage()
}


// Source - https://x.com/dlx/status/1803497996195090879?s=46
extension Gradient {
	init(from: Color, to: Color, with curve: UnitCurve, steps: Int = 10) {
		let colors = stride(from: 0.0, through: 1.0, by: 1.0 / Double(steps))
			.map {
				from.mix(with: to, by: curve.value(at: $0))
			}
		self.init(colors: colors)
	}
}

extension UIImage {
	var prominentColor: UIColor? {
		guard let inputImage = CIImage(image: self) else { return nil }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext()
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
}

/*
 Step 1,
 Create this extension.
 
 extension UIImage {
 var prominentColor: UIColor? {
 guard let inputImage = CIImage(image: self) else { return nil }
 let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
 
 guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
 guard let outputImage = filter.outputImage else { return nil }
 
 var bitmap = [UInt8](repeating: 0, count: 4)
 let context = CIContext()
 context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
 
 return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
 }
 }
 
 Step 2,
 Create a State Variable in ExpandableMusicPlayer called,
 @State private var gradient: AnyGradient = Color.clear.gradient
 
 Final Step,
 In the same ExpandableMusicPlayer onAppear modifier, after setting mainWindow = window, include this line as well,
 gradient = Color(UIImage(named: "Artwork1")?.prominentColor ?? .clear).gradient
 
 Now you will get the most wide prominent color from the artwork image.
 */
