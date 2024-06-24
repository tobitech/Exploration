import SwiftUI

// ScrollView Content Offset using Preference Key
struct ElasticOffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

extension View {
	/// Offset Extractor Custom View Modifier
	@ViewBuilder
	func offsetExtractor(coordinateSpace: String, completion: @escaping (CGRect) -> Void) -> some View {
		self
			.overlay {
				GeometryReader {
					let rect = $0.frame(in: .named(coordinateSpace))
					Color.clear
						.preference(key: ElasticOffsetKey.self, value: rect)
						.onPreferenceChange(ElasticOffsetKey.self, perform: completion)
				}
			}
	}
}

#Preview {
	ElasticScrollContentView()
}
