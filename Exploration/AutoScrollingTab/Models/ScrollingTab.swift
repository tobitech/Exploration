import Foundation

enum ScrollingTab: String, CaseIterable {
	case pic1 = "Pic 1"
	case pic2 = "Pic 2"
	case pic3 = "Pic 3"
	case pic4 = "Pic 4"
	case pic5 = "Pic 5"
	case pic6 = "Pic 6"
	
	// Tab Index
	var index: Int {
		return ScrollingTab.allCases.firstIndex(of: self) ?? 0
	}
	
	// Total Count
	var count: Int {
		return ScrollingTab.allCases.count
	}
}
