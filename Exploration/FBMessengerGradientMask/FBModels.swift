import Foundation

struct FBMessage: Identifiable {
	var id = UUID()
	var message: String
	var isReply: Bool = false
}

let fbMessages: [FBMessage] = [
	.init(message: "Hey, just checking in to see if you’re available this weekend for a quick catch-up."),
	.init(message: "I hope you’re doing well! Let me know if you need help with the project deadline.", isReply: true),
	.init(message: "Meeting rescheduled to Thursday at 3 PM. Can you confirm your availability for the new time?"),
	.init(message: "Don’t forget about our meeting tomorrow morning. Let me know if you need to reschedule."),
	.init(message: "I received your message and will get back to you as soon as possible with an update.", isReply: true),
	.init(message: "Let’s schedule a call for next week. I want to discuss the changes we need to implement."),
	.init(message: "I’m available for a call tomorrow after 2 PM. Let me know what time works for you."),
	.init(message: "Thank you for sending the documents. I’ll review them and get back to you by Friday.", isReply: true),
	.init(message: "Can you send me the updated report before the meeting? I need it for the presentation."),
	.init(message: "Quick reminder: our team meeting is set for Monday at 9 AM. Please confirm your attendance.", isReply: true),
	.init(message: "It was great catching up earlier! Let’s keep in touch and plan something soon."),
	.init(message: "Just wanted to follow up on our previous conversation. Have you had time to think about it?"),
	.init(message: "Please let me know if you’re still interested in moving forward with the proposal we discussed."),
	.init(message: "I’ll be out of the office tomorrow, but feel free to reach me by email if needed.", isReply: true),
	.init(message: "Let’s try to finalize the details before the end of the week. What time works for you?"),
	.init(message: "I’m wrapping up the document revisions now. Do you need anything else before I submit?"),
	.init(message: "It looks like we’re running behind schedule. Can we push our meeting by 30 minutes?"),
	.init(message: "Thanks for your patience. I’m working on your request and will have an update shortly.", isReply: true),
	.init(message: "Let me know if you have any questions about the draft I sent over this afternoon."),
	.init(message: "I’m heading into a meeting now, but I’ll respond to your message as soon as I can.")
]
