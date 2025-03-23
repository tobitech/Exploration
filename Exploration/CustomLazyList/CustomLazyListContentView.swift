//
//  CustomLazyListContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 09/03/2025.
//
//  Source - https://nilcoalescing.com/blog/CustomLazyListInSwiftUI/

import SwiftUI

struct CustomLazyListContentView: View {
	var body: some View {
		VStack {
			RecyclingScrollingLazyView(
				rowIDs: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
				rowHeight: 42,
				content: { id in
//					HStack {
//						Text("Row \(id)")
//						Spacer()
//						Text("Some other row content")
//					}
					MyRow(id: id)
				}
			)
		}
	}
}

#Preview {
	CustomLazyListContentView()
}
