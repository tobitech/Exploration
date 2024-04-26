//
//  MovableGridContentView.swift
//  Exploration
//
//  Created by Tobi Omotayo on 25/04/2024.
//  Source - https://youtu.be/UFiOCcm6zTo?si=NjLUTIvSwL_hLA2R

import SwiftUI

struct MovableGridContentView: View {
	@State private var colors: [Color] = [.red, .blue, .purple, .yellow, .black, .indigo, .cyan, .brown, .mint, .orange]
	@State private var draggingItem: Color?
	
	var body: some View {
		NavigationStack {
			ScrollView(.vertical) {
				let columns = Array(repeating: GridItem(spacing: 10), count: 3)
				LazyVGrid(columns: columns, spacing: 10, content: {
					ForEach(colors, id: \.self) { color in
						GeometryReader {
							let size = $0.size
							RoundedRectangle(cornerRadius: 25.0)
								.fill(color.gradient)
								// Drag
							  /// You can pass any item that conforms to the transferable protocol, such as a string, Data, image (SwiftUl), etc., in the draggable Modifier.
								.draggable(color) {
									// Custom Preview
									/// As of now, there is no way to remove the dropprosal from the draggable modifier; thus, the green plus at the top right will be there.
									/// You can still use the old on Drop modifier with DropDelegate to modify the dropprosal to move type.
									RoundedRectangle(cornerRadius: 25.0)
										.fill(.ultraThinMaterial)
										.frame(width: size.width, height: size.height)
										// .frame(width: 1, height: 1)
								}
								.onAppear {
									/// So now the question is, How do I find the source view? which is being dragged, the answer is simple. Since we used custom previews for our drag provider, and since it's a SwiftUl View, we can use the Swiftul onAppear modifier to let us know which view is being dragged.
									draggingItem = color
								}
							// Drop
							/// With the new DropDestination modifier, we can identify whether there is any file dropped on this view, and it also provides a callback when the target view is being targeted for the drop.
							/// The action callback won't be called because, since in the isTarget callback we're moving the view forth and between, there are no views at the drop point, and thus it won't be called.
								.dropDestination(for: Color.self) { items, location in
									draggingItem = nil
									return false
								} isTargeted: { status in
									/// As you can see, when the source moves around the target view, the isTargetted callback is called, which allows us to find where the source is actually targeting, and thus, with the help of this, we can move items on the grid.
									// print(color)
									if let draggingItem, status, draggingItem != color {
										// Moving Color from source to destination.
										if let sourceIndex = colors.firstIndex(of: draggingItem), 
												let destinationIndex = colors.firstIndex(of: color) {
											withAnimation(.bouncy) {
												let sourceItem = colors.remove(at: sourceIndex)
												colors.insert(sourceItem, at: destinationIndex)
											}
										}
									}
								}

						}
						.frame(height: 100)
					}
				})
				.padding(15)
			}
			.scrollIndicators(.hidden)
			.navigationTitle("Movable Grid")
		}
	}
}

#Preview {
	MovableGridContentView()
}
