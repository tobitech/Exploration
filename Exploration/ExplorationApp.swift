//
//  ExplorationApp.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 24/02/2024.
//

import SwiftUI

@main
struct ExplorationApp: App {
	// Connecting the Scene Delegate to the SwiftUl Life-Cycle via the Delegate Adaptor
	// This is for the CustomAlertView exploration.
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
	var body: some Scene {
		WindowGroup {
			BottomCustomAlertContentView(show: .constant(true))
		}
	}
}
