import SwiftUI

struct RecyclingScrollingLazyView<ID: Hashable, Content: View>: View {
	let rowIDs: [ID]
	let rowHeight: CGFloat
	
	@ViewBuilder
	var content: (ID) -> Content

	var numberOfRows: Int { rowIDs.count }
	@State private var visibleRange: Range<Int> = 0..<1
	
	@State private var rowFragments: Int = 1
	
	/// Since we want SwiftUI to reuse views efficiently, we’ll introduce a reusable identifier for each row, which we'll call a fragment.
	/// To achieve this, we'll define a nested struct called RowData inside our view.
	/// This struct will help manage row identity and ensure proper recycling of views as the user scrolls.
	struct RowData: Identifiable {
		let fragmentID: Int
		let index: Int
		let value: ID
		
		var id: Int { fragmentID }
	}
	
	/// Next, we’ll define a computed property that returns the visible range of rows as RowData.
	/// This ensures that only the necessary rows are displayed while efficiently reusing fragments.
	var visibleRows: [RowData] {
		if rowIDs.isEmpty { return [] }
		
		let lowerBound = min(
			max(0, visibleRange.lowerBound),
			rowIDs.count - 1
		)
		
		let upperBound = max(
			min(rowIDs.count, visibleRange.upperBound),
			lowerBound + 1
		)
		
		let range = lowerBound..<upperBound
		let rowSlice = rowIDs[lowerBound..<upperBound]
		
		let rowData = zip(rowSlice, range).map { row in
			RowData(
				fragmentID: row.1 % max(rowFragments, range.count),
				index: row.1,
				value: row.0
			)
		}
		return rowData
	}

	var body: some View {
		ScrollView(.vertical) {
//			Color.red
//				.frame(height: rowHeight * CGFloat(numberOfRows))
			OffsetLayout(
				totalRowCount: rowIDs.count,
				rowHeight: rowHeight
			) {
				// The fragment ID is used instead of the row ID
				ForEach(visibleRows) { row in
					content(row.value)
						.layoutValue(key: LayoutIndex.self, value: row.index)
				}
			}
		}
		/// Here, we create a vertical ScrollView and use the onScrollGeometryChange() modifier.
		/// This modifier is powerful because it calls the transform method every time the scroll offset updates
		/// but only triggers the action block if the result of the transform changes.
		.onScrollGeometryChange(
			for: Range<Int>.self,
			of: { geometry in
				self.computeVisibleRange(in: geometry.visibleRect)
			},
			action: { oldValue, newValue in
				self.visibleRange = newValue
				self.rowFragments = max(newValue.count, rowFragments)
			}
		)
	}

	func computeVisibleRange(in rect: CGRect) -> Range<Int> {
		let lowerBound = Int(
			max(0, floor(rect.minY / rowHeight))
		)
		let upperBound = max(
			Int(ceil(rect.maxY / rowHeight)), lowerBound + 1
		)
		return lowerBound..<upperBound
	}
}

/// Since our approach reuses a limited number of rows, local state can persist when a row is recycled.
/// For example, storing user input in a @State property may cause it to appear in a different row after scrolling.
/// To avoid this issue, we need to reset or clear any local state whenever the row ID changes.
struct MyRow: View {
	let id: Int
	@State private var text: String = ""
	
	var body: some View {
		TextField("Enter something", text: $text)
			.onChange(of: id) { oldValue, newValue in
				self.text = ""
			}
			.padding()
	}
}
