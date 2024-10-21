//
//  InteractiveToastsContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 18/10/2024.
//  Source - https://youtu.be/nQr6d9_yeG0?si=JUhf88Q64j22OUAS

import SwiftUI

struct InteractiveToastsContentView: View {
	@State private var toasts: [InToast] = []
	
	var body: some View {
		NavigationStack {
			List {
				Text("Dummy List Row View")
			}
			.navigationTitle("Toasts")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Show", action: showToast)
					.tint(.blue)
				}
			}
		}
		/// Place this modifier at the end of the view. If you're in sheet's/fullScreenCover, then place it inside of it as it's based on it's current context and not universal
		.interactiveToasts($toasts)
	}
	
	func showToast() {
		withAnimation(.bouncy) {
			let toast = InToast { id in
				ToastView(id)
			}
			
			toasts.append(toast)
		}
	}
	
	// Your custom toast view.
	/// This is just a simple toast view. Since the toast adopts the AnyView protocol, you can create whatever view you need to be presented in the toast.
	/// NOTE: Do not overweight the toast views.
	@ViewBuilder
	func ToastView(_ id: String) -> some View {
		HStack(spacing: 12) {
			Image(systemName: "airpods.pro")
			
			Text("iJustine's Airpods")
				.font(.callout)
			
			Spacer(minLength: 0)
			
			Button {
				$toasts.delete(id)
			} label: {
				Image(systemName: "xmark.circle.fill")
					.font(.title2)
			}

		}
		.foregroundStyle(.primary)
		.padding(.vertical, 12)
		.padding(.horizontal, 15)
		.padding(.trailing, 10)
		.background {
			Capsule()
				.fill(.background)
			/// Shadows
				.shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
				.shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)
		}
		// .padding(.horizontal, 15)
	}
}

#Preview {
	InteractiveToastsContentView()
}
