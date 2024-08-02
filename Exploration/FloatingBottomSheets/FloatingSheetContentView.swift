//
//  FloatingBottomSheetContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 01/08/2024.
//  Source - https://youtu.be/gxOqwo7bZYE?si=uUIHpNg7T2SZIajx

import SwiftUI

/// As you can see, it's already floated without any tricks, but if you notice that the sheet content is too shady, that's because by default, sheet backgrounds have shadows, and even if you set the presentation background to clear color, those shadows won't go away. To demonstrate this, let me enable the background interaction.
struct FloatingSheetContentView: View {
	@State private var showSheet: Bool = false
	
	// Programmatically changing the size
	/// Learn more here - https://sarunw.com/posts/swiftui-bottom-sheet/
	@State private var selectedDetent: PresentationDetent = .height(100)
	// @State private var possibleDetents: Set<PresentationDetent> = [.height(100), .height(330), .fraction(0.999)]
	@State private var possibleDetents: Set<PresentationDetent> = [.height(100), .height(200), .height(280), .height(330), .fraction(0.8)]
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack {
					Button("Show Sheet") {
						showSheet.toggle()
					}
					.buttonStyle(.borderedProminent)
					Button("Change Size") {
						withAnimation {
							selectedDetent = possibleDetents.randomElement() ?? .height(100)
						}
					}
					.buttonStyle(.borderedProminent)
				}
				Spacer()
			}
			.navigationTitle("Floating Bottom Sheet")
		}
		.floatingBottomSheet(isPresented: $showSheet) {
			// Dummy Dialog Data
//			SheetView(
//				title: "Replace existing folder?",
//				content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//				image: .init(
//					content: "questionmark.folder.fill",
//					tint: .blue,
//					foreground: .white
//				),
//				button1: .init(
//					content: "Replace",
//					tint: .blue,
//					foreground: .white
//				),
//				button2: .init(
//					content: "Cancel",
//					tint: .primary.opacity(0.08),
//					foreground: .primary
//				)
//			)
//			.presentationDetents([.height(330)])
//			.presentationBackgroundInteraction(.enabled(upThrough: .height(330)))
			
			/// There are two things to keep in mind while creating the floating bottom sheets:
			/// 1. Since we removed the sheet's actual background and shadows as well, you need to define the background (and shadows if needed) as per your needs (just like I did to create the custom floating dialog).
			Text("Hello World")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.background.shadow(.drop(radius: 5)), in: .rect(cornerRadius: 25))
				.padding(.horizontal, 15)
				.padding(.top, 15)
			/// Don't use a large presentation detent, Instead, use a fraction (0.999).
			/// This will make sure that the source view is not shrinking when the sheet is being expanded.
				// .presentationDetents([.height(330), .large])
				.presentationDetents(possibleDetents, selection: $selectedDetent)
				.presentationBackgroundInteraction(.enabled(upThrough: .height(330)))
		}
	}
}

// Sample View
struct SheetView: View {
	var title: String
	var content: String
	var image: Config
	var button1: Config
	var button2: Config?
	
	var body: some View {
		VStack(spacing: 15) {
			Image(systemName: image.content)
				.font(.title)
				.foregroundStyle(image.foreground)
				.frame(width: 65, height: 65)
				.background(image.tint.gradient, in: .circle)
			Text(title)
				.font(.title3.bold())
			Text(content)
				.font(.callout)
				.multilineTextAlignment(.center)
				.lineLimit(2)
				.foregroundStyle(.secondary)
			ButtonView(button1)
			if let button2 {
				ButtonView(button2)
			}
		}
		.padding([.horizontal, .bottom], 15)
		.background {
			RoundedRectangle(cornerRadius: 15)
				.fill(.background)
				.padding(.top, 30)
		}
		.shadow(color: .black.opacity(0.12), radius: 8)
		.padding(.horizontal, 15)
	}
	
	@ViewBuilder
	func ButtonView(_ config: Config) -> some View {
		Button {
			
		} label: {
			Text(config.content)
				.fontWeight(.bold)
				.foregroundStyle(config.foreground)
				.padding(.vertical, 10)
				.frame(maxWidth: .infinity)
				.background(config.tint.gradient, in: .rect(cornerRadius: 10))
		}
	}
	
	struct Config {
		var content: String
		var tint: Color
		var foreground: Color
	}
}

#Preview {
	FloatingSheetContentView()
}
