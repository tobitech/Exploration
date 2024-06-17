//
//  FloatingTabBarContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 17/06/2024.
//  Source - https://youtu.be/Y5QnGWOsEmQ?si=5eRmOmRmp0jVpLgU

import SwiftUI

/// iOS 18+ provides a new Tab Protocol that allows you to construct tabs within the TabView, additionally, with a help of single modifier, the tab view can be converted into a sidebar model for iPadOS.
struct FloatingTabBarContentView: View {
	var body: some View {
		TabView {
			Tab.init("Home", systemImage: "house.fill") {
				
			}
			
			Tab.init("Search", systemImage: "magnifyingglass", role: .search) {
				
			}
			
			Tab.init("Notifications", systemImage: "bell.fill") {
				
			}
			
			Tab.init("Settings", systemImage: "gearshape") {
				
			}
		}
		// .tabViewStyle(.tabBarOnly)
		.tabViewStyle(.sidebarAdaptable)
	}
}

#Preview {
	FloatingTabBarContentView()
}
