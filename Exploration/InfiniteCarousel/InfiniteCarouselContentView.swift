//
//  InfiniteCarouselContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 10/04/2024.
// Source - https://youtu.be/Yg2wh9uJ9Fk?si=vWNMKQBAcLgDUM7U

import SwiftUI

struct InfiniteCarouselContentView: View {
	var body: some View {
		NavigationStack {
			CarouselHomeView()
				.navigationTitle("Infinite Carousel")
		}
	}
}

#Preview {
	InfiniteCarouselContentView()
}
