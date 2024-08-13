import SwiftUI

struct ScrollableNavTitleContentView: View {

		private let headerNavHeight: CGFloat = 70
		private let headerText: String = "Insights to your Mind, Body, and Soul"
		@State private var isShowingTopNavTitle: Bool = false
		@State private var offsetY: CGFloat = 0
		@State private var progress: CGFloat = 0
		@Environment(\.verticalSizeClass) private var verticalSizeClass

		// MARK: -
		// MARK: Body Layout
		var body: some View {
				NavigationStack {
						headerOffsetTracker
						ScrollView {
								VStack(spacing: 0) {
										titleText
										totalSpendingRows
								}
								.offset(coordinateSpace: .named("SCROLL")) { offset in
										offsetY = offset
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
						menu
						Text(headerText)
								.frame(maxWidth: .infinity,
											 maxHeight: .infinity)
								.opacity(isShowingTopNavTitle ? 1 : 0)
								.multilineTextAlignment(.center)
								.font(.subheadline)
								.fontWeight(.semibold)
								.allowsHitTesting(false)
						Button(action: {
								print("Open Settings via modal sheet")
						}, label: {
								Image(systemName: "gear")
						})
						.frame(minWidth: 90, alignment: .trailing)
						.padding(verticalSizeClass == .regular ? 10 : 65)
//                        .hidden() //<- Uncomment this, if you don't want to show an action button here. If you remove the button, the navigation title will not be centered.
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
						.fontWeight(.medium)
				}
				.menuOrder(.fixed)
				.padding(verticalSizeClass == .regular ? 10 : 65)
		}

		// MARK: -
		// MARK: Header Offset Tracker
		private var headerOffsetTracker: some View {
				let height: CGFloat = headerNavHeight
				let progress = -(offsetY / height) > 1
				? -1
				: (offsetY > 0
					 ? 0
					 : (offsetY / height))
				return Group {}
				.onChange(of: offsetY, { _, offsetY in
						self.progress = progress
						withAnimation(.easeInOut(duration: 0.2)) {
								isShowingTopNavTitle = offsetY < -headerNavHeight ? true : false
						}
				})
				.opacity(isShowingTopNavTitle ? -progress : 0)
				.hidden()
		}

		// MARK: -
		// MARK: Large Title Text
		private var titleText: some View {
				Text(headerText)
						.frame(maxWidth: .infinity,
									 maxHeight: .infinity,
									 alignment: .topLeading)
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding()
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

#Preview {
	ScrollableNavTitleContentView()
}
