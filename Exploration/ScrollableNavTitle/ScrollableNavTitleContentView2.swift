//
//  ScrollableNavTitleContentView2.swift
//  MenuNav
//
//  Created by Mark Jeschke on 7/11/23.
//  This version supports iOS 15

import SwiftUI

struct ScrollableNavTitleContentView2: View {
	
	private let headerNavHeight: CGFloat = 70
	private let headerText: String = "Insights to your Mind, Body, and Soul"
	@State private var isShowingTopNavTitle: Bool = false
	@State private var offsetY: CGFloat = 0
	@State private var progress: CGFloat = 0
	@Environment(\.verticalSizeClass) private var verticalSizeClass
	
	// MARK: -
	// MARK: Body Layout
	var body: some View {
		NavigationView {
			ZStack {
				ScrollView {
					VStack(spacing: 0) {
						if #available(iOS 16.0, *) {
							titleText
								.fontWeight(.bold)
						} else {
							titleText
						}
						totalSpendingRows
					}
					.offset(coordinateSpace: .named("SCROLL")) { offset in
						offsetY = offset
					}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.coordinateSpace(name: "SCROLL")
			.toolbar {
				ToolbarItem(placement: .principal) {
					navigationBarItems
				}
			}
		}
	}
	
	// MARK: -
	// MARK: Navigation Bar Items
	private var navigationBarItems: some View {
		HStack {
			if #available(iOS 16.0, *) {
				menu
					.menuOrder(.fixed)
			} else {
				menu
			}
			if #available(iOS 16.0, *) {
				navTitle
					.fontWeight(.semibold)
			} else {
				navTitle
			}
			Button(action: {
				print("Open Settings via modal sheet")
			}, label: {
				Image(systemName: "gear")
			})
			.frame(minWidth: 90, alignment: .trailing)
			.padding(verticalSizeClass == .regular ? 10 : 65)
			//                        .hidden() //<- Uncomment this, if you don't want to show an action button here. If you remove the button and its framing, the navigation title will not be centered.
		}
		.frame(width: UIScreen.main.bounds.size.width,
					 alignment: .leading)
	}
	
	// MARK: -
	// MARK: Drop-down Menu
	private var menu: some View {
		Menu {
			Section {
				Button {
					print("Edit content")
				} label: {
					Image(systemName: "square.and.pencil")
					Text("Edit")
				}
				Button {
					print("Copy content")
				} label: {
					Image(systemName: "doc.on.doc")
					Text("Copy")
				}
				Button {
					print("Duplicate content")
				} label: {
					Image(systemName: "plus.square.on.square")
					Text("Duplicate")
				}
				Button {
					print("Share content")
				} label: {
					Image(systemName: "square.and.arrow.up")
					Text("Share")
				}
			}
			Section {
				Button(role: .destructive) {
					print("Delete content")
				} label: {
					Image(systemName: "trash")
					Text("Delete")
				}
			}
		} label: {
			HStack(alignment: .lastTextBaseline, spacing: 5) {
				Text("Income")
				Image(systemName: "chevron.down")
					.imageScale(.small)
			}
		}
		.padding(verticalSizeClass == .regular ? 10 : 65)
	}
	
	private var navTitle: some View {
		Text(headerText)
			.frame(maxWidth: .infinity,
						 maxHeight: .infinity)
			.opacity(isShowingTopNavTitle ? 1 : 0)
			.multilineTextAlignment(.center)
			.font(.subheadline)
			.allowsHitTesting(false)
	}
	
	// MARK: -
	// MARK: Large Title Text
	private var titleText: some View {
		let height: CGFloat = headerNavHeight
		let progress = -(offsetY / height) > 1
		? -1
		: (offsetY > 0
			 ? 0
			 : (offsetY / height))
		return Text(headerText)
		// The .onChange method changed in Xcode 15. Uncomment lines 133-138, and delete 139-144
		//        .onChange(of: offsetY, { _, offsetY in
		//            self.progress = progress
		//            withAnimation(.easeInOut(duration: 0.2)) {
		//                isShowingTopNavTitle = offsetY < -headerNavHeight ? true : false
		//            }
		//        })
			.onChange(of: offsetY, perform: { offsetY in
				self.progress = progress
				withAnimation(.easeInOut(duration: 0.2)) {
					isShowingTopNavTitle = offsetY < -headerNavHeight ? true : false
				}
			})
			.frame(maxWidth: .infinity,
						 maxHeight: .infinity,
						 alignment: .leading)
			.font(.largeTitle)
			.padding()
			.offset(y: -progress * 20) //<- Adds a little Y offset parallax effect.
			.opacity(1 + progress) //<- Slowly fades out the header title as you scroll down.
	}
	
	// MARK: -
	// MARK: Total Spending Rows
	private var totalSpendingRows: some View {
		VStack(alignment: .leading, spacing: 20) {
			ForEach(0..<30, id: \.self) { index in
				HStack(alignment: .top) {
					VStack(alignment: .leading) {
						Text("Total Spending")
							.font(.headline)
						Text("$19.99")
							.font(.subheadline)
					}
					Spacer()
					Text("\(index)")
						.foregroundColor(.secondary)
				}
				Divider()
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
	}
}

// This Preview is for Xcode 15.
//#Preview {
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ScrollableNavTitleContentView2()
	}
}
