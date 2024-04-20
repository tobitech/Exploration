//
//  ScrollableIndicatorsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 20/04/2024.
//  Source - https://youtu.be/sCK0W39nVEk?si=mC5jOkxi5ZVKIhQc
//  Similar Tutorial for Pre iOS 17 - https://youtu.be/z0VWKhpZ5vY?si=PbV6KkXbyjeJrg9C

import SwiftUI

struct ScrollableIndicatorsContentView: View {
	var body: some View {
		ScrollableIndicatorsHomeView()
			.preferredColorScheme(.light)
	}
}

#Preview {
	ScrollableIndicatorsContentView()
}
