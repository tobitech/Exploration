import Foundation
import CoreHaptics
import UIKit

/// A singleton class to manage haptic feedback.
class HapticManager {
	/// Shared instance of HapticManager.
	static let shared = HapticManager()
	
	/// Private initializer to ensure singleton instance.
	private init() {}
	
	/// Triggers haptic feedback based on the provided feedback style.
	/// - Parameter impact: The style of feedback to generate.
	func trigger(_ impact: UIImpactFeedbackGenerator.FeedbackStyle) {
		// Check if the device supports haptic feedback
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			print("Haptic feedback is not supported on this device.")
			return
		}
		
		// Initialize the feedback generator
		let generator = UIImpactFeedbackGenerator(style: impact)
		
		// Prepare the generator to reduce latency
		generator.prepare()
		
		// Trigger the haptic feedback
		generator.impactOccurred()
	}
}
