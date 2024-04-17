import SwiftUI

// A simple class that will be useful to do linear interpolation calculations for our Dynamic Tab Animation.

class LinearInterpolation {
	private var length: Int
	private var inputRange: [CGFloat]
	private var outputRange: [CGFloat]
	
	init(inputRange: [CGFloat], outputRange: [CGFloat]) {
		// Safe Check
		assert(inputRange.count == outputRange.count)
		self.length = inputRange.count - 1
		self.inputRange = inputRange
		self.outputRange = outputRange
	}
	
	func calculate(for x: CGFloat) -> CGFloat {
		// If value is less than its initial input range...
		if x <= inputRange[0] { return outputRange[0] }
		
		for index in 1...length {
			/// Because we need the previous value for x1 / x2 calculation, the starting range is 1 rather than 0.
			let x1 = inputRange[index - 1]
			let x2 = inputRange[index]
			
			let y1 = outputRange[index - 1]
			let y2 = outputRange[index]
			
			// Linear Interpolation Formula: y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
			if x <= inputRange[index] {
				// Applying the formula to the nearest input range.
				let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
				return y
			}
		}
		
		// If value exceeds its maximum input range
		return inputRange[length]
	}
}
