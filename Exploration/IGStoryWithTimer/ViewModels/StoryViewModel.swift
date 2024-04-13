import SwiftUI

class StoryViewModel: ObservableObject {
	// List of Stories
	@Published var stories: [StoryBundle] = [
		StoryBundle(profileName: "iJustine", profileImage: "avi2", stories: [
			IGStory(imageURL: "Pic 1"),
			IGStory(imageURL: "Pic 2"),
			IGStory (imageURL:"Pic 3")
		]),
		StoryBundle(profileName: "Jenna Ezarik", profileImage: "avi3", stories: [
			IGStory(imageURL: "Pic 4"),
			IGStory(imageURL: "Pic 5")
		])
	]
	
	// Properties
	@Published var showStory: Bool = false
	@Published var currentStory: String = "" // Unique StoryBundle ID
}
