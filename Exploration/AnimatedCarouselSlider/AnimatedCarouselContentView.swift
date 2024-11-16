//
//  AnimatedCarousel.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 16/11/2024.
//  Source - https://youtu.be/IK8yQMeyhs4?si=2RoA-zNEO22RcKd6

import SwiftUI

struct AnimatedCarouselContentView: View {
	// View Properties
	@State private var items: [PagingItem] = [
		.init(color: .red, title: "World Clock", subtitle: "View the time in multiple cities around the world"),
		.init(color: .yellow, title: "City Digital", subtitle: "Add a clock for a city to check the time at that location"),
		.init(color: .blue, title: "City Analogue", subtitle: "Add a clock for a city to check the time at that location"),
		.init(color: .green, title: "Next Album", subtitle: "Display upcoming album")
	]
	
	// Customization Properties
	@State private var showPagingControl: Bool = false
	@State private var disablePagingInteraction: Bool = false
	@State private var pagingSpacing: CGFloat = 20
	@State private var titleScrollSpeed: CGFloat = 0.6
	@State private var stretchContent: Bool = false
	
	var body: some View {
		VStack {
			CustomPagingSlider(
				showPagingControl: showPagingControl,
				disablePagingInteraction: disablePagingInteraction,
				titleScrollSpeed: titleScrollSpeed,
				pagingControlSpacing: pagingSpacing,
				data: $items,
				content: { $item in
					RoundedRectangle(cornerRadius: 15)
						.fill(item.color.gradient)
						.frame(width: stretchContent ? nil : 150, height: stretchContent ? 220 : 120)
				},
				titleContent: { $item in
					VStack(spacing: 5) {
						Text(item.title)
							.font(.largeTitle.bold())
						Text(item.subtitle)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
							.frame(height: 45)
					}
					.padding(.bottom, 35)
				}
			)
			/// Use Safe Area padding to avoid clipping of scrollview
			// .padding([.horizontal, .top], 35)
			.safeAreaPadding([.horizontal, .top], 35)
			
			List {
				Toggle("Show Paging Control", isOn: $showPagingControl)
				Toggle("Disable page interaction", isOn: $disablePagingInteraction)
				Toggle("Stretch content", isOn: $stretchContent)
				
				Section("Title Scroll Speed") {
					Slider(value: $titleScrollSpeed)
				}
				
				Section("Paging Spacing") {
					Slider(value: $pagingSpacing, in: 20...40)
				}
			}
			.clipShape(.rect(cornerRadius: 15))
			.padding(15)
		}
	}
}

#Preview {
	AnimatedCarouselContentView()
}
