//
//  HomeView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 26/03/2024.
//

import SwiftUI

struct HomeView: View {
	@State private var selectedTab = "house.fill"
	
	init() {
		UITabBar.appearance().isHidden = true
	}
	
	@Environment(\.colorScheme) var scheme
	
	var body: some View {
		
		// Instagram Home View
		TabView(selection: $selectedTab) {
			FeedView()
				.tag("house.fill")
			Text("Search")
				.tag("magnifyingglass")
			Text("Reels")
				.tag("airplayvideo")
			Text("Liked")
				.tag("suit.heart.fill")
			Text("Account")
				.tag("person.circle")
		}
		.overlay(alignment: .bottom) {
			// Custom Tab Bar
			VStack(spacing: 12) {
				Divider()
					.padding(.horizontal, -15)
				HStack(spacing: 0) {
					TabBarButton(image: "house.fill", selectedTab: $selectedTab)
						.frame(maxWidth: .infinity)
					TabBarButton(image: "magnifyingglass", selectedTab: $selectedTab)
						.frame(maxWidth: .infinity)
					TabBarButton(image: "airplayvideo", selectedTab: $selectedTab)
						.frame(maxWidth: .infinity)
					TabBarButton(image: "suit.heart.fill", selectedTab: $selectedTab)
						.frame(maxWidth: .infinity)
					TabBarButton(image: "person.circle", selectedTab: $selectedTab)
						.frame(maxWidth: .infinity)
				}
			}
			.padding(.horizontal)
			.padding(.bottom, edges?.bottom ?? 15)
			.background(scheme == .dark ? Color.black : Color.white)
		}
		.ignoresSafeArea()
	}
}

// Tab Bar Button
struct TabBarButton: View {
	var image: String
	@Binding var selectedTab: String
	var body: some View {
		Button(action: { selectedTab = image }, label: {
			Image(systemName: image)
				.font(.title2)
				.foregroundStyle(selectedTab == image ? .primary : .secondary)
		})
		.buttonStyle(.plain)
	}
}

#Preview {
	HomeView()
		//  .preferredColorScheme(.dark)
}
