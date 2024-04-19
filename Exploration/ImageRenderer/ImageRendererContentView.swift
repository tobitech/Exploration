//
//  ImageRendererContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 18/04/2024.
// - https://youtu.be/xJtGa935C38?si=NDeNMHb8e4OfOeg2

import SwiftUI

struct ImageRendererContentView: View {
	// Image/PDF Properties
	@State private var generatedImage: Image?
	@State private var generatedPDFURL: URL?
	// For UIKit Share Sheet Approach
	@State private var showShareLink: Bool = false
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			ZStack(alignment: .top) {
				// For smaller devices:
				ViewThatFits {
					ReceiptView()
					ScrollView(.vertical, showsIndicators: false) {
						ReceiptView()
					}
				}
				
				// MARK: Actions
				HStack(spacing: 20) {
					Button {
						
					} label: {
						Image(systemName: "xmark")
							.font(.title3)
					}
					Spacer()
					
					// MARK:  Share Link
					if let generatedImage {
						ShareLink(item: generatedImage, preview: SharePreview("Payment Receipt")) {
							Image(systemName: "square.and.arrow.up")
								.font(.title3)
						}
					}
					
//					if let generatedPDFURL {
//						ShareLink(item: generatedPDFURL, preview: SharePreview("Payment Receipt")) {
//							Image(systemName: "arrow.up.doc")
//								.font(.title3)
//						}
//					}
					
					if let generatedPDFURL {
						Button {
							showShareLink = true
						} label: {
							Image(systemName: "arrow.up.doc")
								.font(.title3)
						}
					}
				}
				.foregroundStyle(.secondary)
				.padding()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			.onAppear {
				// Render after the view is loaded properly.
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					renderView(viewSize: size)
				}
			}
		}
		.sheet(isPresented: $showShareLink) {
			if let generatedPDFURL {
				ShareSheet(items: [generatedPDFURL])
			}
		}
	}
	
	// MARK: Generating Image Once
	// Since it's a static receipt view.
	// Update Image/PDF URL Dynamically If you have Updates on view.
	@MainActor func renderView(viewSize: CGSize) {
		// It's not fitting properly so pass view size here.
		// but for smaller devices, only width is required, height is not since it maybe scrollable.
		let renderer = ImageRenderer(content: ReceiptView().frame(width: viewSize.width, alignment: .center))
		if let image = renderer.uiImage {
			generatedImage = Image(uiImage: image)
		}
		
		// Generating PDF
		var tempURL = URL.cachesDirectory
		let renderURL = tempURL.appending(path: "\(UUID().uuidString).pdf")
		if let consumer = CGDataConsumer(url: renderURL as CFURL),
				let context = CGContext(consumer: consumer, mediaBox: nil, nil) {
			renderer.render { size, renderer in
				var mediaBox = CGRect(origin: .zero, size: size)
				// Drawing the PDF
				context.beginPage(mediaBox: &mediaBox)
				renderer(context)
				context.endPDFPage()
				context.closePDF()
				// Updating PDF URL
				generatedPDFURL = renderURL
			}
		}
	}
}

#Preview {
	ImageRendererContentView()
}
