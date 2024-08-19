//
//  FloatingTabBarContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 19/08/2024.
//  Source - https://youtu.be/JOZv3C1yj7w?si=sAhzuV4r3XjfSIKO

import SwiftUI

struct FloatingTabsContentView: View {
	// View Properties
	@State private var activeTab: FloatingTab = .home
	@State private var isTabBarHidden: Bool = false
	
	var body: some View {
		ZStack(alignment: .bottom) {
			Group {
				if #available(iOS 18, *) {
					TabView(selection: $activeTab) {
						/// As you can see, the default tab bar is still present at the bottom,
						/// and hiding it becomes easier with the introduction of a new API in iOS 18.
						//				Tab.init(value: .home) {
						//					FHomeView()
						//						.toolbarVisibility(.hidden, for: .tabBar)
						//				}
						//				Tab.init(value: .search) {
						//					Text("Search")
						//						.toolbarVisibility(.hidden, for: .tabBar)
						//				}
						//				Tab.init(value: .notifications) {
						//					Text("Notifications")
						//						.toolbarVisibility(.hidden, for: .tabBar)
						//				}
						//				Tab.init(value: .settings) {
						//					Text("Settings")
						//						.toolbarVisibility(.hidden, for: .tabBar)
					}
				} else {
					/// But iOS 17 didn't work like the way iOs 18 works, let me show you an example of that.
					/// The tab bar is initially hidden, but when we update it using custom tab bars,
					/// it becomes visible again at the bottom. Let me show you.
					TabView(selection: $activeTab) {
						FHomeView()
							.tag(FloatingTab.home)
							.background {
								if !isTabBarHidden {
									HideTabBar {
										isTabBarHidden = true
									}
								}
							}
						
						Text("Search")
							.tag(FloatingTab.search)
						
						Text("Notifications")
							.tag(FloatingTab.notifications)
						
						Text("Settings")
							.tag(FloatingTab.settings)
						
					}
					// .overlay {
					/// As you can see, this is the issue I'm referring to. I believe it has existed since iOS 17.3/4.
					/// To completely remove the tab bar in iOS 17 versions, we must first locate the relevant UlTabbarController, and then hide the tab bar completely.
					//					Button {
					//						activeTab = activeTab == .home ? .search : .home
					//					} label: {
					//						Text("Switch Tabs")
					//					}
					//					.offset(y: 100)
					//				}
				}
			}
			
			CustomTabBar(activeTab: $activeTab)
		}
	}
}

/// Now, let me show you how we can make the tabviews adapt to this floating tab bar.
struct FHomeView: View {
	var body: some View {
		NavigationStack {
			ScrollView(.vertical) {
				LazyVStack(spacing: 12) {
					ForEach(1...50, id: \.self) { _ in
						RoundedRectangle(cornerRadius: 12)
							.fill(.background)
							.frame(height: 50)
					}
				}
				.padding(15)
			}
			.navigationTitle("Floating Tab Bar")
			.background(Color.primary.opacity(0.07))
			/// It's simple: just apply safe area bottom padding to the tabviews so they don't get covered beneath the floating tab bar.
			/// NOTE: You must apply it to the views rather than the containers, such as NavigationStack.
			.safeAreaPadding(.bottom, 60)
		}
	}
}

struct HideTabBar: UIViewRepresentable {
	var result: () -> Void
	
	init(result: @escaping () -> Void) {
		UITabBar.appearance().isHidden = true
		self.result = result
	}
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: .zero)
		view.backgroundColor = .clear
		
		DispatchQueue.main.async {
			if let tabController = view.tabController {
				UITabBar.appearance().isHidden = false
				tabController.tabBar.isHidden = true
				result()
			}
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}

extension UIView {
	var tabController: UITabBarController? {
		if let controller = sequence(first: self, next: {
			$0.next
		}).first(where: { $0 is UITabBarController }) as? UITabBarController {
			return controller
		}
		
		return nil
	}
}

#Preview {
	FloatingTabBarContentView()
}
