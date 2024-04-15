//
//  InfiniteLoopingScrollViewContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 15/04/2024.
// Source - https://youtu.be/lyuo59840qs?si=fcchLItwP_kRd9Y6

import SwiftUI

struct LoopingScrollViewContentView: View {
	var body: some View {
		NavigationStack {
			LoopingScrollViewHomeView()
				.navigationTitle("Looping ScrollView")
		}
	}
}

#Preview {
	LoopingScrollViewContentView()
}
