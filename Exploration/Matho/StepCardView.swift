// StepCardView.swift
import SwiftUI

struct StepCardView: View {
	let step: Step
	@State private var showExplanation = false
	@State private var selectedPart: String? = nil
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(step.title)
				.font(.headline)
				.padding(.bottom, 5)
			
			// Interactive Equation
			EquationView(equation: step.equation, selectedPart: $selectedPart)
				.padding(.bottom, 10)
			
			if let part = selectedPart {
				Text("You selected: \(part)")
					.foregroundColor(.gray)
					.padding(.bottom, 10)
			}
			
			Button(action: {
				withAnimation {
					showExplanation.toggle()
				}
			}) {
				Text(showExplanation ? "Hide Explanation" : "More Info")
					.foregroundColor(.blue)
			}
			
			if showExplanation {
				Text(step.explanation)
					.padding(.top, 5)
					.transition(.opacity)
			}
			
			Spacer()
		}
		.padding()
	}
}

