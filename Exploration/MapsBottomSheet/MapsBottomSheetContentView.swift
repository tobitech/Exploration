// Reference - https://youtu.be/CA6GOKDiK0M?si=sZxLhPVU5NIEMYJJ

import MapKit
import SwiftUI

// Till now, I've used the default TabView tab bar to show how to create a customised bottom sheet like Apple Maps. Now let me show you how to create an exact replica of the Apple Maps bottom sheet with Map View and a custom tab bar.
struct MapsBottomSheetContentView: View {
	@State private var showSheet: Bool = false
	@State private var activeTab: MapTab = .devices
	@State private var ignoreTabBar: Bool = false
	
	var body: some View {
		ZStack(alignment: .bottom) {
			if #available(iOS 17, *) {
				Map(initialPosition: .region(.applePark))
			} else {
				Map(coordinateRegion: .constant(.applePark))
			}
			
			// Tab Bar
			TabBar()
				.frame(height: 49)
				.background(.regularMaterial)
		}
		.task {
			showSheet = true
		}
		.sheet(isPresented: $showSheet) {
			ScrollView(.vertical, content: {
				VStack(alignment: .leading, spacing: 15) {
					Text(activeTab.rawValue)
						.font(.title2)
						.fontWeight(.semibold)
					Toggle("Ignore Tab Bar", isOn: $ignoreTabBar)
				}
				.padding()
			})
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			.presentationDetents([.height(60), .medium, .large])
			.presentationCornerRadius(20)
			.presentationBackground(.regularMaterial)
			.presentationBackgroundInteraction(.enabled(upThrough: .large))
			.interactiveDismissDisabled()
			// Add it inside sheet view.
			.bottomMaskForSheet(mask: !ignoreTabBar)
		}
	}
	
	/// Tab Bar
	@ViewBuilder
	func TabBar() -> some View {
		HStack(spacing: 0) {
			ForEach(MapTab.allCases, id: \.rawValue) { tab in
				Button(action: { activeTab = tab }, label: {
					VStack {
						Image(systemName: tab.symbol)
							.font(.title2)
						Text(tab.rawValue)
							.font(.caption2)
					}
					.foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.contentShape(.rect)
				})
				.buttonStyle(.plain)
			}
		}
	}
}

#Preview {
	MapsBottomSheetContentView()
}

extension MKCoordinateRegion {
	// Apple Park Region
	static var applePark: MKCoordinateRegion {
		let center = CLLocationCoordinate2D(latitude: 37.334606, longitude:
		-122.009102)
		return .init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
	}
}
