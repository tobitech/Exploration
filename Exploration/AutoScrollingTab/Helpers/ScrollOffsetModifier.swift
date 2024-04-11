//
//  ScrollOffsetModifier.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 11/04/2024.
//

import SwiftUI

// Offset Key
//struct OffsetKey: PreferenceKey {
//	static var defaultValue: CGRect = .zero
//	
//	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//		value = nextValue()
//	}
//}

// Custom View Modifier Extension
//extension View {
//	@ViewBuilder // Used to find Page Tab View Scroll Offset.
//	func offsetX(_ addObserver: Bool = false, completion: @escaping (CGRect) -> Void) -> some View {
//		self
//			.overlay {
//				if addObserver {
//					GeometryReader {
//						let rect = $0.frame(in: .global)
//						Color.clear
//							.preference(key: OffsetKey.self, value: rect)
//							.onPreferenceChange(OffsetKey.self, perform: completion)
//					}
//				}
//			}
//	}
//}
