import SwiftUI

struct ColorFromImage: View {
	@State private var gradient: AnyGradient = Color.clear.gradient
	
	var body: some View {
		VStack {
			Image(.pic13)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(height: 300)
				.clipShape(.rect(cornerRadius: 20))
			RoundedRectangle(cornerRadius: 20)
				.fill(gradient)
				.frame(height: 300)
			Spacer()
		}
		.padding()
		.onAppear {
			gradient = Color(UIImage(named: "Pic 13")?.prominentColor ?? .clear).gradient
		}
	}
}

#Preview {
	ColorFromImage()
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
