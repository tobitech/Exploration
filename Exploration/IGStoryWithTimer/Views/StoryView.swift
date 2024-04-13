import SwiftUI

struct StoryView: View {
	@EnvironmentObject var storyData: StoryViewModel
	
	var body: some View {
		if storyData.showStory {
			TabView(selection: $storyData.currentStory) {
				ForEach($storyData.stories) { bundle in
					StoryCardView(bundle: bundle)
						.environmentObject(storyData)
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(.black)
			// Transition from bottom
			.transition(.move(edge: .bottom))
		}
	}
}

#Preview {
	IGStoryTimerContentView()
}

struct StoryCardView: View {
	@Binding var bundle: StoryBundle
	@EnvironmentObject var storyData: StoryViewModel
	
	// Timer and changing stories based on timer
	@State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	
	// Progress
	@State private var timerProgress: CGFloat = 0
	
	var body: some View {
		// For 3D Rotation
		GeometryReader { proxy in
			ZStack {
				// Getting current index and updating Data.
				let index = min(Int(timerProgress), bundle.stories.count - 1)
				
				let story = bundle.stories[index]
				Image(story.imageURL)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			// Tapping
			.overlay {
				HStack {
					Rectangle()
						.fill(.black.opacity(0.01))
						.onTapGesture {
							// checking and updating to previous one..
							if (timerProgress - 1) < 0 {
								updateStory(forward: false)
							} else {
								// Update to previous story.
								timerProgress = CGFloat(Int(timerProgress - 1))
							}
						}
					
					Rectangle()
						.fill(.black.opacity(0.01))
						.onTapGesture {
							// checking and update to next one.
							if (timerProgress + 1) > CGFloat(bundle.stories.count) {
								// updating to next bundle.
								updateStory()
							} else {
								// Update to next story.
								timerProgress = CGFloat(Int(timerProgress + 1))
							}
						}
				}
			}
			.overlay(alignment: .topTrailing) {
				// Top Profile View
				HStack(spacing: 13) {
					Image(bundle.profileImage)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 35, height: 35)
						.clipShape(Circle())
					
					Text(bundle.profileName)
						.fontWeight(.bold)
						.foregroundStyle(.white)
					
					Spacer()
					
					// Close Button
					Button(action: {
						withAnimation {
							storyData.showStory = false
						}
					}, label: {
						Image(systemName: "xmark")
							.font(.title2)
							.foregroundStyle(.white)
					})
					.buttonStyle(.plain)
				}
				.padding()
			}
			// Top Timer Capsule
			.overlay(alignment: .top) {
				HStack(spacing: 5) {
					ForEach(bundle.stories.indices) { index in
						GeometryReader { proxy in
							let width = proxy.size.width
							
							// getting progress by eliminating current index with progress, so that remaining all will be at 0 when previous is loading
							// Setting max to 1... Min to 0... for perfect timer
							let progress = timerProgress - CGFloat(index)
							let perfectProgress = min(max(progress, 0), 1)
							
							Capsule()
								.fill(.white.opacity(0.5))
								.overlay(alignment: .leading) {
									Capsule()
										.fill(.white)
										.frame(width: width * perfectProgress)
								}
						}
					}
				}
				.frame(height: 1.4)
				.padding(.horizontal)
			}
			// Rotation
			.rotation3DEffect(
				getAngle(proxy: proxy),
				axis: (x: 0, y: 1, z: 0),
				anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
				perspective: 2.5
			)
		}
		// Resetting Timer
		.onAppear {
			timerProgress = 0
		}
		.onReceive(timer) { _ in
			// Updating Seen Status in Realtime...
			if storyData.currentStory == bundle.id {
				if !bundle.isSeen {
					bundle.isSeen = true
				}
				
				// Updating timer..
				if timerProgress < CGFloat(bundle.stories.count) {
					timerProgress += 0.03
				} else {
					updateStory()
				}
			}
		}
	}
	
	// Updating On End
	func updateStory(forward: Bool = true) {
		let index = min(Int(timerProgress), bundle.stories.count - 1)
		let story = bundle.stories[index]
		
		if !forward {
			// if it's not first item, then move backwards, else set timer to 0.
			if let first = storyData.stories.first, first.id != bundle.id {
				let bundleIndex = storyData.stories.firstIndex { currentBundle in
					return bundle.id == currentBundle.id
				} ?? 0
				withAnimation {
					storyData.currentStory = storyData.stories[bundleIndex - 1].id
				}
			} else {
				timerProgress = 0
			}
			return
		}
		
		// Checking if it's the last
		if let last = bundle.stories.last, last.id == story.id {
			// if there is another story, then we move to that, else we dismiss the view.
			if let lastBundle = storyData.stories.last, lastBundle.id == bundle.id {
				// closing story view
				withAnimation {
					storyData.showStory = false
				}
				// timerProgress = 0
			} else {
				// updating to the next one
				let bundleIndex = storyData.stories.firstIndex { currentBundle in
					return bundle.id == currentBundle.id
				} ?? 0
				withAnimation {
					storyData.currentStory = storyData.stories[bundleIndex + 1].id
				}
			}
		}
	}
	
	func getAngle(proxy: GeometryProxy) -> Angle {
		// Converting Offset into 45 degrees rotation.
		let progress = proxy.frame(in: .global).minX / proxy.size.width
		let rotationAngle: CGFloat = 45
		let degrees = rotationAngle * progress
		return Angle(degrees: Double(degrees))
	}
}
