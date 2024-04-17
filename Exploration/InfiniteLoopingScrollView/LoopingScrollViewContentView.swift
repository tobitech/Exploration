//
//  InfiniteLoopingScrollViewContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 15/04/2024.
//  Source - https://youtu.be/lyuo59840qs?si=fcchLItwP_kRd9Y6
//  Reference - https://medium.com/dvt-engineering/building-a-seamless-infinite-wrap-around-carousel-in-swift-using-uicollectionview-no-external-dfe1d07a7e8d

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
