import SwiftUI

/// Next, we need an interpolation technique that will map the input range to the given output range values. 
/// For example, a progress of 0.5 will be mapped as 10 when the input range is [0, 0.5, 1] and the output range is [0, 10, 15].
/// Please be aware that the input and output range array counts must match for this function to work.
extension CGFloat {
	func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
		// If value is less than its initial input range.
		let x = self
		let length = inputRange.count - 1
		if x <= inputRange[0] { return outputRange[0] }
		
		for index in 1...length {
			let x1 = inputRange[index - 1]
			let x2 = inputRange[index]
			
			let y1 = outputRange[index - 1]
			let y2 = outputRange[index]
			
			// Linear Interpolation Formula: y1 + ((y2-y1) / (x2-x1)) * (x-x1)
			if x <= inputRange[index] {
				let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
				return y
			}
		}
		
		// If value exceeds its maximum input range
		return outputRange[length]
	}
}
