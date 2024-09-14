import SwiftUI

struct NewTabContentView: View {
	@State private var selectedTab: Int = 0
	@State private var previousTab: Int = 0
	
	var body: some View {
		VStack(spacing: 0) {
			// Content area with sliding transitions
			ZStack {
				Group {
					switch selectedTab {
					case 0:
						TabView1()
					case 1:
						TabView2()
					case 2:
						TabView3()
					case 3:
						TabView4()
					case 4:
						TabView5()
					default:
						TabView1()
					}
				}
				.transition(transitionDirection)
			}
			.animation(.easeInOut, value: selectedTab)
			.edgesIgnoringSafeArea(.top)
			
			// Custom Tab Bar
			HStack {
				ForEach(0..<5) { index in
					Button(action: {
						previousTab = selectedTab
						selectedTab = index
					}) {
						VStack {
							Image(systemName: "circle.fill")
								.foregroundColor(selectedTab == index ? .blue : .gray)
							Text("Tab \(index + 1)")
								.foregroundColor(.primary)
						}
					}
					.frame(maxWidth: .infinity)
				}
			}
			.padding()
			.background(Color(UIColor.systemBackground).shadow(radius: 2))
		}
	}
	
	// Determines the transition direction based on tab index
	private var transitionDirection: AnyTransition {
		if selectedTab > previousTab {
			return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
		} else if selectedTab < previousTab {
			return .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
		} else {
			return .identity
		}
	}
}

// Sample Tab Views
struct TabView1: View {
	var body: some View {
		Color.white
			.overlay(Text("Tab 1").font(.largeTitle))
	}
}

struct TabView2: View {
	var body: some View {
		Color.white
			.overlay(Text("Tab 2").font(.largeTitle))
	}
}

struct TabView3: View {
	var body: some View {
		Color.white
			.overlay(Text("Tab 3").font(.largeTitle))
	}
}

struct TabView4: View {
	var body: some View {
		Color.white
			.overlay(Text("Tab 4").font(.largeTitle))
	}
}

struct TabView5: View {
	var body: some View {
		Color.white
			.overlay(Text("Tab 5").font(.largeTitle))
	}
}

// Preview
struct NewTabContentView_Previews: PreviewProvider {
	static var previews: some View {
		NewTabContentView()
	}
}
