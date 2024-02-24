import AppIntents
import Foundation

// iOS 17 made app intent easier than ever; we can simply define an action for our widget button through the app intents.
// NOTE: Your action blocks on widget view won't work unless they're app intents.
struct ToggleStateIntent: AppIntent {
	static var title: LocalizedStringResource = "Toggle Task State"
	
	// Parameters: - You can define basic parameters like this; these parameters can be passed with the button call from widgets.
	@Parameter(title: "Task ID")
	// You may wonder why I used String instead of UUID in my task model because Appintent Parameters accepts the basic types like int, string, bool, and enum.
	// That's the reason I used a string as the task ID.
	// Using UUID will throw a compiler error.
	var id: String
	
	init() {}
	
	init(id: String) {
		self.id = id
	}
	
	func perform() async throws -> some IntentResult {
		// UPDATE YOUR DATABASE HERE.
		// Use async if necessary and make any network update calls here for database updates or any other network-based requests.
		if let index = TaskDataModel.shared.tasks.firstIndex(where: { $0.id == self.id }) {
			TaskDataModel.shared.tasks[index].isCompleted.toggle()
			print("DataStore Updated")
		}
		return .result()
	}
}
