import SwiftUI

/// Size and the minX properties will be used for dynamic sizing and positioning the indicator in the tab bar.
struct TabModel: Identifiable {
	private(set) var id: Tab
	var size: CGSize = .zero
	var minX: CGFloat = .zero
	
	enum Tab: String, CaseIterable {
		case research = "Research"
		case deployment = "Deployment"
		case analytics = "Analytics"
		case audience = "Audience"
		case privacy = "Privacy"
	}
}
