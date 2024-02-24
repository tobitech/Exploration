import Foundation

struct TaskModel: Identifiable {
	var id: String = UUID().uuidString
	let title: String
	var isCompleted: Bool = false
	
	// Add other properties below...
}

// Sample Data Model - you can replace this with your own network calls.
class TaskDataModel {
	static let shared = TaskDataModel()
	
	var tasks: [TaskModel] = [
		.init(title: "Record Video"),
		.init(title: "Edit Video"),
		.init(title: "Publish it")
	]
}

