//
//  FeedView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 26/03/2024.
//

import SwiftUI

struct FeedView: View {
	var body: some View {
		VStack {
			HStack {
				Button(action: {}, label: {
					Image(systemName: "plus.app")
						.font(.title)
						.foregroundStyle(.primary)
				})
				.buttonStyle(.plain)
				Spacer()
				Button(action: {}, label: {
					Image(systemName: "paperplane")
						.font(.title)
						.foregroundStyle(.primary)
				})
				.buttonStyle(.plain)
			}
			.padding()
			.overlay {
				Text("Instagram")
					.font(.title2)
					.fontWeight(.semibold)
			}
			
			ScrollView(.vertical, showsIndicators: false) {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 15) {
						Button(action: {}, label: {
							Image(systemName: "person.circle.fill")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 55, height: 55)
								.clipShape(Circle())
						})
						.buttonStyle(.plain)
						.overlay(alignment: .bottomTrailing) {
							Image(systemName: "plus.circle.fill")
								.font(.title)
								.foregroundStyle(.blue)
								.background(Color.white.clipShape(Circle()))
								.offset(x: 8, y: 5)
						}
					}
					.padding()
				}
				Divider()
				.padding(.horizontal, -15)
				
				VStack(spacing: 25) {
					// Posts...
				}
			}
		}
	}
}

#Preview {
	HomeView()
}
