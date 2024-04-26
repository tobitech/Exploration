//
//  MaterialCarouselContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 25/04/2024.
//  Source - https://youtu.be/j1UKn-7DkE4?si=PGsqxVFsr3zvzqgT

import SwiftUI

struct MaterialCarouselContentView: View {
	var body: some View {
		NavigationStack {
			MaterialCarouselHomeView()
				.navigationTitle("Carousel")
		}
	}
}

#Preview {
	MaterialCarouselContentView()
}
