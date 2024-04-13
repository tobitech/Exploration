//
//  ControlCenterContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 13/04/2024.
//  Source - https://youtu.be/k0mm-Dh9C9U?si=6Sf4UtmML7LDwBCG

import SwiftUI

struct ControlCenterContentView: View {
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea  = $0.safeAreaInsets
			
			ControlCenterHomeView(size: size, safeArea: safeArea)
				.ignoresSafeArea(.container, edges: .all)
		}
	}
}

#Preview {
	ControlCenterContentView()
}
