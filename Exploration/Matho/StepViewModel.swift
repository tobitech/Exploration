// StepViewModel.swift
import Foundation

class StepViewModel: ObservableObject {
	@Published var steps: [Step] = [
		Step(title: "Step 1: Subtract 3 from both sides",
				 equation: "2x + 3 - 3 = 11 - 3",
				 explanation: "This isolates the term with the variable on one side."),
		Step(title: "Step 2: Simplify both sides",
				 equation: "2x = 8",
				 explanation: "Simplifying gives us a simple equation to solve for x."),
		Step(title: "Step 3: Divide both sides by 2",
				 equation: "2x ÷ 2 = 8 ÷ 2",
				 explanation: "This isolates x by dividing the coefficient of x."),
		Step(title: "Step 4: Simplify to find x",
				 equation: "x = 4",
				 explanation: "We've solved for x!")
	]
	
	@Published var currentStepIndex: Int = 0
	
	var progress: Double {
		return Double(currentStepIndex + 1) / Double(steps.count)
	}
	
	func nextStep() {
		if currentStepIndex < steps.count - 1 {
			currentStepIndex += 1
		}
	}
	
	func prevStep() {
		if currentStepIndex > 0 {
			currentStepIndex -= 1
		}
	}
}
