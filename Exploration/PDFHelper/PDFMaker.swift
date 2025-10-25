import SwiftUI
import PDFKit

struct PDFMaker {
	/// Page Size
	struct PageSize {
		let size: CGSize
		
		init(
			width: CGFloat,
			height: CGFloat
		) {
			self.size = .init(width: width, height: height)
		}
		
		static func a4() -> Self {
			.init(width: 595.2, height: 841.8)
		}
		
		static func usLetter() -> Self {
			.init(width: 612, height: 792)
		}
	}
	
	/// For a basic PDF generation, this is enough, but if you need to set more info such as description,
	/// permission access, and so on, add those appropriate properties here!
	static func create<PageContent: View>(
		_ pageSize: PageSize = .a4(),
		pageCount: Int,
		format: UIGraphicsPDFRendererFormat = .default(),
		fileURL: URL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).pdf"),
		@ViewBuilder pageContent: (_ pageIndex: Int) -> PageContent
	) throws -> URL? {
		let size = pageSize.size
		let rect = CGRect(origin: .zero, size: size)
		
		let renderer = UIGraphicsPDFRenderer(bounds: rect, format: format)
		
		try renderer.writePDF(to: fileURL) { context in
			// Drawing SwiftUI views as each page!
			for index in 0..<pageCount {
				// Begin's each page
				context.beginPage()
				
				let pageContent = pageContent(index)
				let swiftUIRenderer = ImageRenderer(
					content: pageContent
						.frame(width: size.width, height: size.height)
				)
				swiftUIRenderer.proposedSize = .init(size)
				
				// Flipping content in the right direction
				context.cgContext.translateBy(x: 0, y: size.height)
				context.cgContext.scaleBy(x: 1, y: -1)
				
				swiftUIRenderer.render { _, swiftUIContext in
					/// SwiftUl ImageRenderer API enables us to directly draw the layer into the PDFRenderer,
					/// eliminating the need for a UlHosting Controller or converting SwiftUl views into images.
					/// ⚠️ However, this functionality is limited to the views that is supported by the ImageRenderer API.
					swiftUIContext(context.cgContext)
				}
			}
		}
		
		return fileURL
	}
}
