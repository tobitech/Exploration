//
//  PaywallStoreKitContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 12/05/2025.
//  Source - https://youtu.be/a-jQ_5yEfUc?si=3k3sKEO5CayJuoXB

import StoreKit
import SwiftUI

/// Creating a Paywall in SwiftUl is incredibly straightforward. There are numerous modifiers available to customise the SubscriptionStoreView. To explore these modifiers, simply type in the following keywords:
/// - subscription
/// - product
/// - store
/// When you start using these keywords, you'll discover a wide range of modifiers specifically designed for customising the Subscription View. Experiment with these modifiers to gain a deeper understanding of their functionality.
/// Additionally, instead of displaying the entire group of products, we can restrict the number of products displayed on the Subscription View.
///
///
/// Now, let's make the Subscription Products fixed at the bottom position and display them as a paged carousel. Additionally, we'll add a Restore Purchases button.
/// Currently, we can add Terms of Service and Privacy Policy Links using native Modifiers, but these links appear at the top of the products. I don't want them to be displayed at the top. Instead, I want them to be at the bottom.
/// Therefore, I'll remove the native links and create a custom one for those at the bottom.
///
///
/// SubscriptionStoreView enables us to create a custom Header View for PayWalls. To achieve this, we simply need to place our custom view within the "marketingContent" parameter. (This functionality is applicable only when using with product IDs.)
/// On the other hand, if you use it with a group ID, you can utilize the following code snippet to place your custom view:
/// SubscriptionStoreView(grouplD) {
/// 	Custom View
/// }
///
///
/// The default SubscriptionStoreView has its own loading view (as you may have noticed). Currently, there's no way to determine its loading state.
/// However, we can use the "storeProductTasks" modifier, which essentially retrieves the store products from the provided IDs. By utilizing this modifier, we can ascertain whether the SubscriptionStoreView has successfully loaded the products or not.
/// NOTE:
/// You can use this modifier to retrieve store products and create a complete Paywall view from scratch!
///
///
/// 1. OnInAppPurchaseStart: This event will notify us when the user initiates a purchase by pressing the subscribe button.
/// 2. OnInAppPurchaseCompletion: This event will be triggered when the purchase is canceled, closed, failed, or successful. You can use switch cases to determine the actual outcome of the purchase.
/// 3. SubscriptionStatusTask: This modifier will monitor any changes in the specified group, indicating whether the user is subscribed, expired, revoked, or otherwise. This information can be used to determine the user's subscription status.
/// Additionally, you can add your own TransactionListener if desired. Now, let's run the app to observe the results!
///
///
/// That's the wrap! Additionally, you can add the "Manage Subscription" button right next to the "Terms of Service" button if the user is subscribed.
/// It's easy to present a "Manage Subscription" view.
/// Just use the modifier". manageSubscriptionsSheet".
/// I hope iOS 19 will even add more options to the SubscriptionStoreView. Thanks for watching! For more videos like this, please like and subscribe. Have a nice day, folks!
struct PaywallStoreKitContentView: View {
	@State private var isLoadingCompleted: Bool = false
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let isSmalleriPhone = size.height < 700
			
			// SubscriptionStoreView(groupID: "21475CF6")
			// .subscriptionStoreControlStyle(.compactPicker)
			VStack(spacing: 0) {
				Group {
					if isSmalleriPhone {
						SubscriptionStoreView(
							productIDs: Self.productIDs,
							marketingContent: {
								CustomMarketingView()
							})
						.subscriptionStoreControlStyle(.compactPicker, placement: .bottomBar)
					} else {
						SubscriptionStoreView(
							productIDs: Self.productIDs,
							marketingContent: {
								CustomMarketingView()
							})
						.subscriptionStoreControlStyle(.pagedProminentPicker, placement: .bottomBar)
					}
				}
				.subscriptionStorePickerItemBackground(.ultraThinMaterial)
				.storeButton(.visible, for: .restorePurchases)
				.storeButton(.hidden, for: .policies)
				// Let's look at some essential modifiers that will be useful for paywalls.
				.onInAppPurchaseStart { product in
					print("Show Loading Screen")
					print("Purchasing \(product.displayName)")
				}
				.onInAppPurchaseCompletion { product, result in
					switch result {
					case let .success(result):
						switch result {
						case .success(_):
							print(("Success and verify purchase using verification result."))
						case .pending:
							print("Pending Action")
						case .userCancelled:
							print("user Canceled")
						@unknown default:
							fatalError()
						}
					case let .failure(error):
						print(error.localizedDescription)
					}
					
					print("Hide Loading Screen...")
				}
				.subscriptionStatusTask(for: "21475CF6") {
					if let result = $0.value {
						let premiumUser = result.filter({ $0.state == .subscribed }).isEmpty
						print("User subscribed = \(premiumUser)")
					}
				}
				
				// Privacy Policy & Terms of Service
				HStack(spacing: 3) {
					Link("Terms of Service", destination: URL(string: "https://apple.com")!)
					Text("and")
					Link("Privacy Policy", destination: URL(string: "https://apple.com")!)
				}
				.font(.caption)
				.padding(.bottom, 10)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.opacity(isLoadingCompleted ? 1 : 0)
			.background(BackdropView())
			.overlay {
				if !isLoadingCompleted {
					ProgressView()
						.font(.largeTitle)
				}
			}
			.animation(.easeInOut(duration: 0.35), value: isLoadingCompleted)
			.storeProductsTask(for: Self.productIDs) { @MainActor collection in
				if let products = collection.products,
					 products.count == Self.productIDs.count {
					try? await Task.sleep(for: .seconds(0.1))
					isLoadingCompleted = true
				}
			}
		}
		.environment(\.colorScheme, .dark)
		.tint(.white)
	}
	
	static var productIDs: [String] {
		return ["pro_weekly", "pro_monthly", "pro_yearly"]
		// return ["pro_weekly", "pro_monthly"]
	}
	
	// Backdrop View
	@ViewBuilder
	func BackdropView() -> some View {
		GeometryReader {
			let size = $0.size
			Image(.pic7)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: size.width, height: size.height)
				.scaleEffect(1.5)
				.blur(radius: 70, opaque: true)
				.overlay {
					Rectangle()
						.fill(.black.opacity(0.2))
				}
				.ignoresSafeArea()
		}
	}
	
	// Custom Marketing View (Header View)
	@ViewBuilder
	func CustomMarketingView() -> some View {
		VStack(spacing: 15) {
			// App Screenshots View
			HStack(spacing: 25) {
				ScreenshotsView(
					["Pic 1", "Pic 2", "Pic 3"],
					offset: -200
				)
				ScreenshotsView(
					["Pic 4", "Pic 5", "Pic 6"],
					offset: -350
				)
				ScreenshotsView(
					["Pic 7", "Pic 9", "Pic 10"],
					offset: -250
				)
				.overlay {
					ScreenshotsView(
						["Pic 13", "Pic 11", "Pic 12"],
						offset: -150
					)
					.visualEffect { content, proxy in
						content
							.offset(x: proxy.size.width + 25)
					}
				}
			}
			.frame(maxHeight: .infinity)
			.offset(x: 20)
			// Progress Blur Mask
			.mask {
				LinearGradient(
					colors: [
						.white,
						.white.opacity(0.9),
						.white.opacity(0.7),
						.white.opacity(0.4),
						.clear
					],
					startPoint: .top,
					endPoint: .bottom
				)
				.ignoresSafeArea()
				.padding(.bottom, -40)
			}
			
			VStack(spacing: 6) {
				Text("App Name")
					.font(.title3)
				
				Text("Membership")
					.font(.largeTitle.bold())
				
				Text("Lorem Ipsum is simply dummy text\nof the printing and typesetting industry.")
					.font(.callout)
					.multilineTextAlignment(.center)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.foregroundStyle(.white)
		.padding(.top, 15)
		.padding(.bottom, 10)
		.padding(.horizontal, 15)
	}
	
	@ViewBuilder
	func ScreenshotsView(
		_ content: [String],
		offset: CGFloat
	) -> some View {
		/// The reason we're using a disabled Scrollview instead of directly using VStack is that if we use VStack directly, it will attempt to fit all the image views within its height, while ScrollView will place them one after another.
		ScrollView(.vertical) {
			VStack(spacing: 10) {
				ForEach(content.indices, id: \.self) { index in
					Image(content[index])
						.resizable()
						.aspectRatio(contentMode: .fill)
				}
			}
			.offset(y: offset)
		}
		.scrollDisabled(true)
		.scrollIndicators(.hidden)
		.rotationEffect(.init(degrees: -30), anchor: .bottom)
		.scrollClipDisabled()
	}
}

#Preview {
	PaywallStoreKitContentView()
}
