//
//  QuotesContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 24/08/2024.
//  Source - https://blog.logrocket.com/implementing-tags-swiftui/

import SwiftUI

struct QuotesContentView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					Text("Select as many as you like to have on your list.")
						.font(.title)
						.foregroundStyle(.secondary)
					FlowLayout(data: quotes) { tag in
						Button {
							
						} label: {
							Text(tag.name)
								.font(.subheadline.weight(.medium))
								.padding(10)
	//							.overlay {
	//								Capsule()
	//									.stroke(.quaternary, lineWidth: 1.0)
	//							}
								.background(.quinary, in: .capsule)
						}
						.buttonStyle(.plain)
					}
					Text("This is a good foot note")
						.foregroundStyle(.secondary)
					Text("This is a good foot note")
						.font(.title)
						.foregroundStyle(.secondary)
				}
				.padding()
				.navigationTitle("Tags")
			}
		}
	}
}

#Preview {
	QuotesContentView()
}
