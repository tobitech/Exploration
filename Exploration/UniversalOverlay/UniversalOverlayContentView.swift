//
//  UniversalOverlayContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 21/10/2024.
//  Source - https://youtu.be/B8JGLwg_yxg?si=WqptiistWtTczD9p

import SwiftUI

struct UniversalOverlayContentView: View {
	@State private var show: Bool = false
	@State private var showSheet: Bool = false
	
	var body: some View {
		NavigationStack {
			List {
				Button("Floating Video") {
					show.toggle()
				}
				.tint(.blue)
				/// It will add the view on top the entire SwiftUI App, so you can use it anywhere in your code.
				.universalOverlay(show: $show) {
					Circle()
						.fill(.red)
						.frame(width: 50, height: 50)
						.onTapGesture {
							print("Tapped")
						}
				}
				
				Button("Show Dummy Sheet") {
					showSheet.toggle()
				}
				.tint(.blue)
			}
			.navigationTitle("Universal Overlay")
		}
		.sheet(isPresented: $showSheet) {
			Text("Hello from Sheets!!")
		}
	}
}

/// If you want previews to be working, then you must need to wrap your preview view with the RootView Wrapper.
#Preview {
	UniRootView {
		UniversalOverlayContentView()
	}
}
