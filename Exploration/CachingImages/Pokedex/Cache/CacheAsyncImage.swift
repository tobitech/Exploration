import SwiftUI

struct CacheAsyncImage<Content: View>: View {
	
	private let url: URL
	private let scale: CGFloat
	private let transaction: Transaction
	private let content: (AsyncImagePhase) -> Content
	
	init(
		url: URL,
		scale: CGFloat = 1.0,
		transaction: Transaction = Transaction(),
		@ViewBuilder content: @escaping (AsyncImagePhase) -> Content
	) {
		self.url = url
		self.scale = scale
		self.transaction = transaction
		self.content = content
	}
	
	var body: some View {
		if let cachedImage = ImageCache[url] {
			let _ = print("cache \(url.absoluteString)")
			content(.success(cachedImage))
		} else {
			let _ = print("request \(url.absoluteString)")
			AsyncImage(
				url: url,
				scale: scale,
				transaction: transaction,
				content: { phase in
					cacheAndRender(phase: phase)
				}
			)
		}
	}
	
	func cacheAndRender(phase: AsyncImagePhase) -> some View {
		if case let .success(image) = phase {
			ImageCache[url] = image
		}
		return content(phase)
	}
}

fileprivate class ImageCache {
	static private var cache: [URL: Image] = [:]
	static subscript(url: URL) -> Image? {
		get{
			return ImageCache.cache[url]
		}
		set {
			ImageCache.cache[url] = newValue
		}
	}
}
