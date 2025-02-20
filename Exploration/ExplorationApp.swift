import SwiftUI

@main
struct ExplorationApp: App {
	// Connecting the Scene Delegate to the SwiftUl Life-Cycle via the Delegate Adaptor
	// This is for the CustomAlertView exploration.
	// @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
	var body: some Scene {
		WindowGroup {
			JournalImagePickerContentView()
			// IntroPageContentView()
			// PhotosAppContentView()
		}
	}
}
