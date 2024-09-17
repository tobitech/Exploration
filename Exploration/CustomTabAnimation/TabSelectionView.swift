import SwiftUI

struct TabSelectionView: View {
	@Binding var tabSelection: Int
	@Namespace private var buttonId
	private let selectionButtons = ["Discussion", "Schedule", "Resources"]
	
	var body: some View {
		HStack(alignment: .top) {
			ForEach(selectionButtons.indices, id: \.self) { index in
				VStack {
					Button(selectionButtons[index]) {
						withAnimation {
							tabSelection = index
						}
					}
					.foregroundStyle(tabSelection == index ? .primary : .secondary)
					.padding(.horizontal)
					
					if tabSelection == index {
						Capsule()
							.frame(width: 80, height: 4)
							.padding(.horizontal, 4)
							.foregroundStyle(.purple)
							.matchedGeometryEffect(id: "ID", in: buttonId)
					} else {
						EmptyView()
							.frame(height: 4)
							.matchedGeometryEffect(id: "ID", in: buttonId)
					}
				}
			}
			Spacer()
		}
	}
}
