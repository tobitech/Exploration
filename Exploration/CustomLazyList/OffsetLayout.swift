import SwiftUI

struct OffsetLayout: Layout {
	let totalRowCount: Int
	let rowHeight: CGFloat
	
	/// The sizeThatFits() method calculates the total height by multiplying the number of rows by the height of each row.
	/// This ensures the scrollable area reflects the full dataset.
	func sizeThatFits(
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) -> CGSize {
		CGSize(
			width: proposal.width ?? 0,
			height: rowHeight * CGFloat(totalRowCount)
		)
	}
	
	/// In placeSubviews(), each visible row is positioned at its correct vertical offset.
	/// To determine its position, we need to know its index within the full list.
	/// We achieve this by defining a LayoutValueKey, which allows us to pass the index to the layout.
	func placeSubviews(
		in bounds: CGRect,
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) {
		for subview in subviews {
			let index = subview[LayoutIndex.self]
			subview
				.place(
					at: CGPoint(
						x: bounds.midX,
						y: bounds.minY + rowHeight * CGFloat(index)
					),
					anchor: .top,
					proposal: .init(
						width: proposal.width, height: proposal.height
					)
				)
		}
	}
}

struct LayoutIndex: LayoutValueKey {
	static var defaultValue: Int = 0
	
	typealias Value = Int
}
