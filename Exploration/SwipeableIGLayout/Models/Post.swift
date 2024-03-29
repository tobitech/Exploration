import Foundation

// Post Model and Data
struct Post: Identifiable {
	var id = UUID().uuidString
	var user: String
	var profile: String
	var profileImage: String
	var postTitle: String
	var time: String
}

var posts = [
	Post(user: "iJustine", profile: "p1", profileImage: "post2", postTitle: "iPhone 11...", time: "58 min ago"),
	Post(user: "iJustine", profile: "p1", profileImage: "post2", postTitle: "iPhone 11...", time: "58 min ago"),
	Post(user: "iJustine", profile: "p1", profileImage: "post2", postTitle: "iPhone 11...", time: "58 min ago"),
	Post(user: "iJustine", profile: "p1", profileImage: "post2", postTitle: "iPhone 11...", time: "58 min ago"),
	Post(user: "iJustine", profile: "p1", profileImage: "post2", postTitle: "iPhone 11...", time: "58 min ago")
]
