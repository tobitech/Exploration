//
//  MorphingFABContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 25/06/2025.
//  Source - https://youtu.be/sbvAoIBVQzk?si=Iaeg9viKAvak54sD

import SwiftUI

struct MorphingFABContentView: View {
	@State private var showExpandedContent: Bool = false
	
	var body: some View {
		NavigationStack {
			List {
				
			}
			.navigationTitle("Morphing Button")
		}
		.overlay(alignment: .bottomTrailing) {
			MorphingButton(
				backgroundColor: .black,
				showExpandedContent: $showExpandedContent,
				label: {
					Image(systemName: "plus")
						.font(.title3)
						.fontWeight(.semibold)
						.foregroundStyle(.background)
						.frame(width: 45, height: 45)
				},
				content: {
					VStack(spacing: 20) {
						RowView("paperplane", "Send")
						RowView("arrow.trianglehead.2.counterclockwise", "Swap")
						RowView("arrow.down", "Receive")
					}
					.padding(.horizontal, 5)
					.padding(.vertical, 10)
				},
				expandedContent: {
					// Your expanded content view
					VStack {
						HStack {
							Text("Expanded View")
								.font(.title2)
								.fontWeight(.semibold)
							
							Spacer(minLength: 0)
							
							Button {
								showExpandedContent = false
							} label: {
								Image(systemName: "xmark.circle.fill")
									.font(.title)
							}
						}
						.padding(.leading, 10)
						
						Spacer()
					}
					.foregroundStyle(.background)
					.padding(15)
				}
			)
			.padding(15)
		}
	}
	
	// Dummy Menu Row
	@ViewBuilder
	func RowView(
		_ image: String,
		_ title: String
	) -> some View {
		HStack(spacing: 18) {
			Image(systemName: image)
				.font(.title2)
				.frame(width: 45, height: 45)
				.background(.background, in: .circle)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(title)
					.font(.title3)
					.foregroundStyle(.background)
					.fontWeight(.semibold)
				
				Text("This is a sample text for description")
					.font(.callout)
					.foregroundStyle(.gray)
					.lineLimit(2)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding(10)
		.contentShape(.rect)
		.onTapGesture {
			showExpandedContent.toggle()
		}
	}
}

#Preview {
	MorphingFABContentView()
}
