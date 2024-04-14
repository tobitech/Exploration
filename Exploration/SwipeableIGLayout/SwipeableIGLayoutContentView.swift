//
//  SwipeableIGLayoutContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 26/03/2024.
// Source - https://www.youtube.com/watch?v=62u7s1Z3aSo&t=46s

import SwiftUI

struct SwipeableIGLayoutContentView: View {
	var body: some View {
		HomeView()
	}
}

// Global usage values...
var rect = UIScreen.main.bounds
var edges = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets
