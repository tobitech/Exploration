//
//  TabViewOffsetContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 31/05/2024.
//  Source - https://youtu.be/-ysC37TRgTg?si=JT-fDIC4n3XgP8lj

import SwiftUI

struct TabViewOffsetContentView: View {
	// View Properties
	@State private var activeTab: DummyTab = .home
	var offsetObserver = PageOffsetObserver()
	
	var body: some View {
		VStack(spacing: 15) {
			TabBar(.gray)
			/// I also wanted to mask the tab bar colour changes, which means that the current tab colour will transition fluidly in response to the page offset.
				.overlay {
					if let collectionViewBounds = offsetObserver.collectionView?.bounds {
						GeometryReader {
							let width = $0.size.width
							let tabCount = CGFloat(DummyTab.allCases.count)
							let capsuleWidth = width / tabCount
							/// Now, turn the page offset into progress, and use that progress to move the indicator from one tab to another.
							let progress = offsetObserver.offset / collectionViewBounds.width
							
							/// Now that the masking effect is complete, let us display an indicator.
							/// NOTE: Disable user interaction for this overlay. (allowHitTesting(false))
							Capsule()
								.fill(.black)
								.frame(width: capsuleWidth)
									.offset(x: progress * capsuleWidth)
							
							TabBar(.white)
								.mask(alignment: .leading) {
									Capsule()
										.frame(width: capsuleWidth)
										.offset(x: progress * capsuleWidth)
								}
						}
					}
				}
				.background(.ultraThinMaterial)
				.clipShape(.capsule)
				.shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
				.shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
				.padding([.horizontal, .top], 15)
			
			TabView(selection: $activeTab) {
				DummyTab.home.color
					.tag(DummyTab.home)
				/// We're traversing the superview to discover the associated UlCollection View, which will only work if our Representable View exists within the PageTabView.
				/// Therefore, I'm attaching it as a background view for the First Tab.
					.background {
						/// This will ensure that the observer is only added once not several times.
						if !offsetObserver.isObserving {
							FindCollectionView {
								offsetObserver.collectionView = $0
								offsetObserver.observe()
							}
						}
					}
				
				DummyTab.chats.color
					.tag(DummyTab.chats)
				
				DummyTab.calls.color
					.tag(DummyTab.calls)
				
				DummyTab.settings.color
					.tag(DummyTab.settings)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
//			.overlay {
//				Text("\(offsetObserver.offset.formatted())")
//					.font(.title)
//					.foregroundStyle(.white)
//			}
		}
	}
	
	@ViewBuilder
	func TabBar(_ tint: Color, _ weight: Font.Weight = .regular) -> some View {
		HStack(spacing: 0) {
			ForEach(DummyTab.allCases, id: \.rawValue) { tab in
				Text(tab.rawValue)
					.font(.callout)
					.fontWeight(weight)
					.padding(.vertical, 10)
					.foregroundStyle(tint)
					.frame(maxWidth: .infinity)
					.contentShape(.rect)
					.onTapGesture {
						withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
							activeTab = tab
						}
					}
			}
		}
	}
}

#Preview {
	TabViewOffsetContentView()
}

/// SwiftUl Page TabView is built on top of the UlKit's UlCollection View, which in turn provides the content offset, so now let's extract the UlKit's UlCollection View from the SwiftUl Page Tab View.
/// And that's it. You can now read the scroll offset from the page tab view and apply it wherever you wish.
/// NOTE: The scroll view offset can also be obtained using the same way!
@Observable /// If you want to support iOS 16 conform to ObservableObject instead.
class PageOffsetObserver: NSObject {
	var collectionView: UICollectionView?
	var offset: CGFloat = 0
	private(set) var isObserving: Bool = false
	
	deinit {
		/// This will remove the observer whenever the class is deinitialised
		remove()
	}
	
	func observe() {
		// Safe Method
		guard !isObserving else { return }
		/// As previously stated, we will be observing the collectionview's contentOffset property.
		collectionView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
		isObserving = true
	}
	
	func remove() {
		isObserving = false
		collectionView?.removeObserver(self, forKeyPath: "contentOffset")
	}
	
	/// I didn't use the delegates methods to fetch the content offset because
	/// I didn't want to remove any of SwiftUl's default functionality by customizing the delegates methods,
	/// so I'm using the observe method to monitor content offset changes.
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard keyPath == "contentOffset" else { return }
		if let contentOffset = (object as? UICollectionView)?.contentOffset {
			offset = contentOffset.x
		}
	}
}

/// As you can see, we successfully identified the corresponding UlCollection View from the PageTabView, Now, let's write the code that will observe/monitor the collectionview contentOffsets.
struct FindCollectionView: UIViewRepresentable {
	var result: (UICollectionView) -> Void
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .clear
		DispatchQueue.main.asyncAfter(deadline: .now()) {
			if let collectionView = view.collectionSuperView {
				result(collectionView)
			}
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}

extension UIView {
	// Finding the CollectionView by traversing the superview.
	var collectionSuperView: UICollectionView? {
		if let collectionView = superview as? UICollectionView {
			return collectionView
		}
		
		return superview?.collectionSuperView
	}
}
