//
//  StackedNotificationsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 15/05/2024.
//  Source - https://youtu.be/8ZI2CVHthWU?si=ZM6DgaXyzSMwq2Q1

import SwiftUI

struct StackedNotificationsContentView: View {
	var body: some View {
		ZStack {
			GeometryReader { _ in
				Image(.wallpaper)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.ignoresSafeArea()
			}
			StackedNotificationsHomeView()
		}
		.environment(\.colorScheme, .dark)
	}
}

#Preview {
	StackedNotificationsContentView()
}
