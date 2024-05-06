//
//  DateTextFieldContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 04/05/2024.
//  Source - https://youtu.be/wnrtI4qXghc?si=QJySX0zCpx9HjMzh

import SwiftUI

struct DateTextFieldContentView: View {
	// View Properties
	@State private var date: Date = .now
	
	var body: some View {
		NavigationStack {
			DateTF(date: $date) { date in
				return date.formatted()
			}
			.navigationTitle("Date Picker TextField")
		}
	}
}

#Preview {
	DateTextFieldContentView()
}
