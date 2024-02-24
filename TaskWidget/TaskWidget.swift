import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> TaskEntry {
		// customise your placeholder view here.
		// SINCE I'VE MADE NO NETWORK CALLS, I'M RETURNING ALL THE SNAPSHOTS AND PLACEHOLDER VIEWS WITH MY DEFAULT DATA.
		// REPLACE THIS WITH NETWORK-ORIENTED DATA FOR YOUR SUITABLE USE CASE.
		TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
	}
	
	func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
		let entry = TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		// The timeline entries should be set for your best use case, such as 2 hours once, 1 hour once, etc. I've already mentioned that l've set a timeline for my use case.
		// FETCH DATA HERE
		let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
		let latestEntries = [TaskEntry(lastThreeTasks: latestTasks)]
		let timeline = Timeline(entries: latestEntries, policy: .atEnd)
		completion(timeline)
	}
}

struct TaskEntry: TimelineEntry {
	let date: Date = .now
	// *First Three. I'm going to display the first three tasks on the array because of the widget size. You may increase the size based on the widget family.
	var lastThreeTasks: [TaskModel]
}

struct TaskWidgetEntryView : View {
	var entry: Provider.Entry
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Tasks")
				.fontWeight(.semibold)
				.padding(.bottom, 10)
			
			VStack(alignment: .leading, spacing: 5) {
				if self.entry.lastThreeTasks.isEmpty {
					Text("No tasks found")
						.font(.caption)
						.foregroundStyle(.secondary)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					ForEach(self.entry.lastThreeTasks) { task in
						HStack(spacing: 5) {
							// SwiftUl widgets support only two interaction modes:
							// 1. Button with intent
			        // 2. Toggle
			        // All remaining interactions will be ignored.
							Button(
								intent: ToggleStateIntent(id: task.id),
								label: {
									Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
										.foregroundStyle(.blue)
								}
							)
							.buttonStyle(.plain)
							
							VStack(alignment: .leading, spacing: 5) {
								Text(task.title)
									.textScale(.secondary)
									.lineLimit(1)
									.strikethrough(task.isCompleted, pattern: .solid, color: .primary)
								Divider()
							}
						}
						
						if task.id != self.entry.lastThreeTasks.last?.id {
							Spacer(minLength: 0)
						}
					}
				}
			}
		}
	}
}

struct TaskWidget: Widget {
	let kind: String = "TaskWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			if #available(iOS 17.0, *) {
				TaskWidgetEntryView(entry: entry)
					.containerBackground(.fill.tertiary, for: .widget)
			} else {
				TaskWidgetEntryView(entry: entry)
					.padding()
					.background()
			}
		}
		.configurationDisplayName("Task Widget")
		.description("This is an example of an interactive widget.")
	}
}

#Preview(as: .systemSmall) {
	TaskWidget()
} timeline: {
	TaskEntry(lastThreeTasks: TaskDataModel.shared.tasks)
}
