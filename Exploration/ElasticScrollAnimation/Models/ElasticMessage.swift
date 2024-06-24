import Foundation

struct ElasticMessage: Identifiable {
	var id = UUID()
	var image: String
	var name: String
	var message: String
	var online: Bool
	var read: Bool
}

let sampleMessages: [ElasticMessage] = [
	.init(image: "Pic 1", name: "Sibel McAdam", message: "Hi, what's up", online: true, read: false),
	.init(image: "Pic 2", name: "Miranda", message: "How are you doing?", online: false, read: false),
	.init(image: "Pic 3", name: "Jenna", message: "Don't waste time", online: false, read: true),
	.init(image: "Pic 4", name: "Emily", message: "Playing mass effect", online: true, read: true),
	.init(image: "Pic 5", name: "Augustine Fresh", message: "Hi, what's up", online: true, read: false),
	.init(image: "Pic 6", name: "Emma", message: "I mean we definitely could", online: true, read: false),
	.init(image: "Pic 7", name: "Jennifer", message: "Have you ever tried surfing?", online: true, read: false),
	.init(image: "Pic 8", name: "Maciej Miranda", message: "Danny is incredibly funny!!", online: true, read: false),
	.init(image: "Pic 9", name: "Zara Osborne", message: "How are you doing?", online: true, read: false),
	.init(image: "Pic 10", name: "Rui Black", message: "Are we able to delivery on time?", online: false, read: true),
	.init(image: "Pic 11", name: "George Klooney", message: "Hi, what's up", online: true, read: false),
	.init(image: "Pic 12", name: "Ammie Gold", message: "Hi, what's up", online: true, read: false),
	.init(image: "Pic 13", name: "Paul Winstantley", message: "Hi, what's up", online: true, read: false),
	.init(image: "Pic 14", name: "Amna Partridge", message: "Tomorrow we are ✈️✈️", online: false, read: false),
	.init(image: "Pic 15", name: "Paris Kirby", message: "I am running out of ideas...", online: true, read: true)
]
