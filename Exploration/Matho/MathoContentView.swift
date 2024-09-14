// ContentView.swift
import SwiftUI

struct MathoContentView: View {
	@StateObject private var viewModel = StepViewModel()
	
	var body: some View {
		VStack {
			// Progress Bar
			ProgressView(value: viewModel.progress)
				.progressViewStyle(LinearProgressViewStyle())
				.padding()
			
			// Problem Statement
			VStack {
				Text("Solve for ")
					.font(.headline) +
				Text("x")
					.font(.headline)
					.italic()
				Text(viewModel.steps.first?.equation ?? "")
					.font(.title)
					.padding(.top, 5)
			}
			.padding()
			
			// Step Cards
			TabView(selection: $viewModel.currentStepIndex) {
				ForEach(0..<viewModel.steps.count, id: \.self) { index in
					StepCardView(step: viewModel.steps[index])
						.tag(index)
						.animation(.easeInOut)
				}
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.animation(.easeInOut, value: viewModel.currentStepIndex)
			
			// Navigation Buttons
			HStack {
				Button(action: {
					viewModel.prevStep()
				}) {
					HStack {
						Image(systemName: "chevron.left")
						Text("Previous")
					}
					.padding()
				}
				.disabled(viewModel.currentStepIndex == 0)
				
				Spacer()
				
				Button(action: {
					viewModel.nextStep()
				}) {
					HStack {
						Text("Next")
						Image(systemName: "chevron.right")
					}
					.padding()
				}
				.disabled(viewModel.currentStepIndex == viewModel.steps.count - 1)
			}
			.padding()
		}
	}
}


#Preview {
	MathoContentView()
}
