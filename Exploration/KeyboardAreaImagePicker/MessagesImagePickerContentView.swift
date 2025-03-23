import PhotosUI
import SwiftUI

struct MessagesImagePickerContentView: View {
	@State private var text: String = ""
	@State private var showPhotosPicker: Bool = false
	@State private var photoItem: PhotosPickerItem?
	@State private var inputOffset: CGFloat = 0
	@State private var yOffset: CGFloat = 0.0
	@State private var sheetHeight: CGFloat = 0.0
	@FocusState private var isFocused: Bool

	var body: some View {
		NavigationStack {
			VStack {
				VStack {
					Text("yOffset: \(yOffset)")
					Text("Sheet Proxy Height: \(sheetHeight)")
				}
				.font(.footnote)
				ScrollView(.vertical) {
					MessagesList()
				}
				.onScrollGeometryChange(for: CGFloat.self, of: { geometry in
					geometry.contentOffset.y
				}, action: { oldValue, newValue in
					yOffset = newValue
					print("Height is now \(newValue)")
					print("inputOffset is now \(inputOffset)")
					print("inputOffset + newValue is now \(inputOffset + newValue)")
					if isFocused {
						inputOffset = min(max(inputOffset + newValue, 336), 0)
						print("inputOffset:", inputOffset)
					}
				})
				.scrollDismissesKeyboard(.interactively)
				Spacer()
				MessageInput()
					.offset(y: -inputOffset)
			}
			.onChange(of: isFocused, { oldValue, newValue in
				if newValue {
					showPhotosPicker = false
					inputOffset = 0
				}
			})
			.sheet(isPresented: $showPhotosPicker) {
				GeometryReader { proxy in
					PhotosPicker(selection: $photoItem) {}
						.photosPickerStyle(.inline)
						.photosPickerDisabledCapabilities([.collectionNavigation, .search])
						.presentationDetents([.height(336), .large])
						.presentationBackground(.clear)
						.presentationBackgroundInteraction(.enabled(upThrough: .large)
						)
						.preference(key: SheetHeightPreferenceKey.self,
												value: proxy.size.height)
					//				.onGeometryChange(for: CGFloat.self) { proxy in
					//					proxy.size.height
					//				} action: { newValue in
					//					sheetHeight = newValue
					//				}
				}
				.onPreferenceChange(SheetHeightPreferenceKey.self) { newHeight in
					sheetHeight = newHeight
				}
			}
		}
	}

	@ViewBuilder
	func MessagesList() -> some View {
		ForEach(0..<10, id: \.self) { index in
			HStack(alignment: .top) {
				VStack(alignment: .leading) {
					Text("Sender \(index + 1)")
					Text("Message \(index + 1)")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
				Spacer()
				Text(Date().formatted(date: .abbreviated, time: .omitted))
					.font(.subheadline)
			}
			.padding(.vertical, 5)
			.padding(.horizontal)
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}

	@ViewBuilder
	func MessageInput() -> some View {
		HStack {
			Button {
				UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
				withAnimation {
					inputOffset = 336
				}
				showPhotosPicker = true
			} label: {
				Image(systemName: "plus.circle.fill")
					.font(.title)
					.foregroundStyle(.tertiary)
			}
			.buttonStyle(.plain)

			HStack(alignment: .bottom) {
				TextField(
					"iMessage",
					text: $text,
					axis: .vertical
				)
				.lineLimit(10)
				.focused($isFocused)
				Button {
				} label: {
					Image(systemName: "arrow.up.circle.fill")
						.font(.title2)
				}
				.tint(.primary)
				.disabled(text.isEmpty)
			}
			.padding(.vertical, 5)
			.padding(.horizontal, 10)
			.background(.regularMaterial, in: .rect(cornerRadius: 30))
		}
		.padding(.horizontal, 10)
		.padding(.bottom, 10)
		.background(.background)
	}
}

#Preview {
	MessagesImagePickerContentView()
}


struct SheetHeightPreferenceKey: PreferenceKey {
		static var defaultValue: CGFloat = 0
		static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
				value = nextValue()
		}
}
