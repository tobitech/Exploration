//
//  FBGradientMaskContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 09/09/2024.
//  Source - https://youtu.be/U-9idyGKwgY?si=l5QQ3m_vKt8HCaCZ

import SwiftUI

struct FBGradientMaskContentView: View {
	var body: some View {
		NavigationStack {
			FBGradientMaskHomeView()
				.navigationTitle("Messages")
		}
	}
}

#Preview {
	FBGradientMaskContentView()
}
