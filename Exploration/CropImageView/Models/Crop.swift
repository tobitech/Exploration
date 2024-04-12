import Foundation

// Crop Config
enum Crop: Equatable {
	case circle
	case rectangle
	case square
	case custom(CGSize)
	
	var name: String {
		switch self {
		case .circle:
			return "Circle"
		case .rectangle:
			return "Rectangle"
		case .square:
			return "Square"
		case let .custom(size):
			return "Custom \(Int(size.width)) x \(Int(size.height))"
		}
	}
	
	// You can define custom sizes for circle, rectangle, square by doing the same thing as custom size.
	// This represents the crop view's size.
	var size: CGSize {
		switch self {
		case .circle:
			return .init(width: 300, height: 300)
		case .rectangle:
			return .init(width: 300, height: 500)
		case .square:
			return .init(width: 300, height: 300)
		case let .custom(size):
			return size
		}
	}
}
