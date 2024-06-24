//
//  ElasticScrollContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 24/06/2024.
//  Source - https://youtu.be/Xjp1bIoSOHs?si=RVNCw6EQTztARswB

import SwiftUI

struct ElasticScrollContentView: View {
	var body: some View {
		NavigationStack {
			ElasticScrollHomeView()
				.navigationTitle("Messages")
		}
	}
}

#Preview {
	ElasticScrollContentView()
}
