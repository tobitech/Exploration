import SwiftUI

struct StoryBundle: Identifiable, Hashable {
	var id = UUID().uuidString
	var profileName: String
	var profileImage: String
	var isSeen: Bool = false
	var stories: [IGStory]
}

struct IGStory: Identifiable, Hashable {
	var id = UUID().uuidString
	var imageURL: String
}
