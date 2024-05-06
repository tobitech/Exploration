//
//  GridAnimationContentView.swift
//  Exploration
//
//  Created by Tobi Omotayo on 06/05/2024.
//  Source - https://youtu.be/fBCu7rM5Vkw?si=eo1wFfwDNt0k4cKa

import SwiftUI

struct GridAnimationContentView: View {
	var body: some View {
		NavigationStack {
			GridAnimationHomeView()
				.toolbar(.hidden, for: .navigationBar)
		}
	}
}

#Preview {
	GridAnimationContentView()
}
