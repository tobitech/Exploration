import SwiftUI

enum ViewSelection: String, CaseIterable, Identifiable {
	case list = "List"
	case grid = "Grid"
	
	var id: String { self.rawValue }
}

struct PickerContentView: View {
	@State private var selection: ViewSelection = .grid
	
	var body: some View {
		VStack {
			// Picker with segmented style
			Picker("Select View", selection: $selection) {
				ForEach(ViewSelection.allCases) { view in
					Text(view.rawValue).tag(view)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			.padding()
			
			// Container for the views with custom transitions
			ZStack {
				if selection == .list {
					ListView()
						.transition(.moveInFromLeftOutToLeft)
				}
				if selection == .grid {
					GridView()
						.transition(.moveInFromRightOutToRight)
				}
			}
			// Apply snappy animation to the transitions
			.animation(.easeOut(duration: 0.15), value: selection)
			// .animation(.snappy(duration: 0.2, extraBounce: 0.0), value: selection)
			// .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0), value: selection)
		}
	}
}

// Custom transitions
extension AnyTransition {
	static var moveInFromLeftOutToLeft: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .move(edge: .leading),
			removal: .move(edge: .leading)
		)
	}

	static var moveInFromRightOutToRight: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .move(edge: .trailing),
			removal: .move(edge: .trailing)
		)
	}
}

// Sample GridView
struct GridView: View {
	let items = Array(1...50)
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns, spacing: 20) {
				ForEach(items, id: \.self) { item in
					Rectangle()
						.fill(Color.blue)
						.frame(height: 100)
						.overlay(
							Text("Item \(item)")
								.foregroundColor(.white)
								.bold()
						)
						.cornerRadius(8)
				}
			}
			.padding()
		}
	}
}

// Sample ListView
struct ListView: View {
	let items = Array(1...50)
	
	var body: some View {
		List(items, id: \.self) { item in
			Text("Item \(item)")
				.padding()
		}
		.listStyle(PlainListStyle())
	}
}

#Preview {
	PickerContentView()
}
