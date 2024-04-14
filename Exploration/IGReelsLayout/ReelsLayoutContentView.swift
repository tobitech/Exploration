//
//  ReelsLayoutContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 14/04/2024.
// Source - https://youtu.be/LCDIALAp_X8?si=y5Q-e4G4mu1U2Y4A

import SwiftUI

struct ReelsLayoutContentView: View {
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea = $0.safeAreaInsets
			
			ReelsLayoutHomeView(size: size, safeArea: safeArea)
				.ignoresSafeArea(.container, edges: .all)
		}
	}
}

#Preview {
	ReelsLayoutContentView()
}
