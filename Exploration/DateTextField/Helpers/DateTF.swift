import SwiftUI

struct DateTF: View {
	// Config
	var components: DatePickerComponents = [.date, .hourAndMinute]
	@Binding var date: Date
	var formattedString: (Date) -> String
	
	// View Properties
	/// We can use this viewID to locate the associated UlKit textfield in the active key window.
	@State private var viewID: String = UUID().uuidString
	@FocusState private var isActive: Bool
	
	var body: some View {
		TextField(viewID, text: .constant(formattedString(date)))
			.focused($isActive)
			.toolbar {
				ToolbarItem(placement: .keyboard) {
					Button("Done") {
						isActive = false
					}
					.tint(.primary)
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
		/// Because we inserted TextField Extractor as an overlay, it prevents interaction with the textfield, you may add this as a background instead of an overlay, and the textfield will work properly, but I do not want the textfield to enable selection, so l am staying with this way.
			.overlay {
				/// You can use this code to create your custom keyboard view for SwiftUl's TextField.
				AddInputViewToTF(id: viewID) {
					// SwiftUI Date Picker
					DatePicker("", selection: $date, displayedComponents: components)
						.labelsHidden()
						.datePickerStyle(.wheel)
				}
				.onTapGesture {
					isActive = true
				}
			}
	}
}

fileprivate struct AddInputViewToTF<Content: View>: UIViewRepresentable {
	var id: String
	@ViewBuilder var content: Content
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .clear
		DispatchQueue.main.async {
			if let window = view.window, let textField = window.allSubviews(type: UITextField.self).first(where: { $0.placeholder == id }) {
				// We don't want the TextField cursor to show, so we will hide it.
				textField.tintColor = .clear
				
				// Converting SwiftUI View to UIKit View
				let hostView = UIHostingController(rootView: content).view!
				hostView.backgroundColor = .clear
				hostView.frame.size = hostView.intrinsicContentSize
				
				// Adding as input view.
				textField.inputView = hostView
				textField.reloadInputViews()
			}
		}
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {}
}

/// This helper method iterates across each view, retrieving all subviews that match the specified UlView type.
fileprivate extension UIView {
	func allSubviews<T: UIView>(type: T.Type) -> [T] {
		var resultViews = subviews.compactMap { $0 as? T }
		for view in subviews {
			resultViews.append(contentsOf: view.allSubviews(type: type))
		}
		
		return resultViews
	}
}

#Preview {
	DateTextFieldContentView()
}
