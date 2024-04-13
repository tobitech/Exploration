import SwiftUI

struct IGStoryTimerHomeView: View {
	@StateObject private var viewModel = StoryViewModel()
	
	var body: some View {
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				ScrollView(.horizontal, showsIndicators: false) {
					// Showing User Stories.
					HStack(spacing: 12) {
						Button(action: {}, label: {
							Image("avi1")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 50, height: 50)
								.clipShape(.circle)
								.overlay(alignment: .bottomTrailing) {
									Image(systemName: "plus")
										.font(.footnote)
										.padding(5)
										.background(.blue, in: .circle)
										.foregroundStyle(.white)
										.padding(2)
										.background(.black, in: .circle)
										.offset(x: 10.0, y: 10.0)
								}
						})
						.buttonStyle(.plain)
						.padding(.trailing, 10)
						
						// Stories...
						// In iOS 15 we can directly pass bindings from ForEach View.
						ForEach($viewModel.stories) { bundle in
							ProfileView(bundle: bundle)
								.environmentObject(viewModel)
						}
					}
					.padding()
					.padding(.top, 10)
				}
			}
			.navigationTitle("Instagram")
		}
		.overlay {
			StoryView()
				.environmentObject(viewModel)
		}
	}
}

#Preview {
	IGStoryTimerContentView()
}

struct ProfileView: View {
	@Binding var bundle: StoryBundle
	@Environment(\.colorScheme) private var scheme
	@EnvironmentObject var storyData: StoryViewModel
	
	var body: some View {
		Image(bundle.profileImage)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 50, height: 50)
			.clipShape(Circle())
		// Progress Ring showing only stories not seen.
			.padding(2)
			.background(scheme == .dark ? .black : .white, in: .circle)
			.padding(3)
			.background(
				LinearGradient(
					colors: [
						.red, .orange, .red, .orange
					],
					startPoint: .top, 
					endPoint: .bottom
				)
				.clipShape(Circle())
				.opacity(bundle.isSeen ? 0 : 1)
			)
			.onTapGesture {
				withAnimation {
					bundle.isSeen = true
					// Saving current bundle and toggling story.
					storyData.currentStory = bundle.id
					storyData.showStory = true
				}
			}
	}
}
