//
//  AutoScrollingTabContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 11/04/2024.
// Source - https://youtu.be/W-uSGXhuFHY?si=2b27l9JW26RKxETI

import SwiftUI

struct AutoScrollingTabContentView: View {
	var body: some View {
		AutoScrollingHomeView()
			.preferredColorScheme(.dark)
	}
}

#Preview {
	AutoScrollingTabContentView()
}
