// EquationView.swift
import SwiftUI

struct EquationView: View {
	let equation: String
	@Binding var selectedPart: String?
	
	var body: some View {
		let parts = equationComponents(equation: equation)
		
		return HStack(spacing: 0) {
			ForEach(parts, id: \.self) { part in
				Text(part)
					.font(.title2)
					.padding(2)
					.background(isSelectable(part: part) ? Color.yellow.opacity(0.3) : Color.clear)
					.onTapGesture {
						if isSelectable(part: part) {
							selectedPart = part
						}
					}
			}
		}
	}
	
	func equationComponents(equation: String) -> [String] {
		// Split the equation into components (simplified)
		let operators = ["+", "-", "=", "×", "÷", "^"]
		var components: [String] = []
		var current = ""
		
		for char in equation {
			if operators.contains(String(char)) || char == " " {
				if !current.isEmpty {
					components.append(current)
					current = ""
				}
				if char != " " {
					components.append(String(char))
				}
			} else {
				current.append(char)
			}
		}
		if !current.isEmpty {
			components.append(current)
		}
		return components
	}
	
	func isSelectable(part: String) -> Bool {
		// Define which parts are selectable
		return !["+", "-", "=", "×", "÷", "^"].contains(part)
	}
}
