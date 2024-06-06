//
//  CustomImageCroppingContentView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 31/05/2024.
//  Source - https://youtu.be/mTV2gXs56OU?si=IoBCdmuxRayeZ7NZ

import SwiftUI

var UniversalSafeOffsets = UIApplication.shared.windows.first?.safeAreaInsets

struct ImageCroppingView: View {
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

struct ViewFinder: View {
	@Binding var imageWidth: CGFloat
	@Binding var imageHeight: CGFloat
	@State private var center: CGFloat = 0
	
	@State private var activeOffset: CGSize = CGSize(width: 0, height: 0)
	@Binding var finalOffset: CGSize
	
	@State private var activeMagnification: CGFloat = 1
	@Binding var finalMagnification: CGFloat
	
	@State private var dotSize: CGFloat = 13
	var dotColor = Color.white.opacity(0.9)
	var surroundingColor = Color.black.opacity(0.45)
	
	var body: some View {
		// These are the views for the surrounding rectangles
		Group {
			Rectangle()
				.foregroundStyle(.red.opacity(0.3))
				.foregroundStyle(surroundingColor)
				.frame(width: ((imageWidth - getDimension(width: imageWidth, height: imageHeight)) / 2) + activeOffset.width + (getDimension(width: imageWidth, height: imageHeight) * (1 - activeMagnification) / 2), height: imageHeight)
			
			Rectangle()
				.foregroundStyle(.blue.opacity(0.3))
				.foregroundStyle(surroundingColor)
		}
	}
	
	// Helpers
	/// This function gets the offset for the surrounding views that obscure what has not been selected in the crop
	func getSurroundViewOffsets(horizontal: Bool, leftOfUp: Bool) -> CGFloat {
		let initialOffset: CGFloat = horizontal ? imageWidth : imageHeight
		let negativeValue: CGFloat = leftOfUp ? -1 : 1
		let compensator = horizontal ? activeOffset.width : activeOffset.height
		
		return (((negativeValue * initialOffset) - (negativeValue * (initialOffset - getDimension(width: imageWidth, height: imageHeight)) / 2)) + (compensator / 2) + (-negativeValue * getDimension(width: imageWidth, height: imageHeight) * (1 - activeMagnification) / 4))
	}
	
	/// This function determines the intended magnification you were going for . It does so by measuring the distance you dragged in both dimensions and comparing it against longest edge of the image. The larger ratio is determined to be the magnification that you intended.
	func getMagnification(_ dragTranslation: CGSize) -> CGFloat {
		if (getDimension(width: imageWidth, height: imageHeight) - dragTranslation.width) / getDimension(width: imageWidth, height: imageHeight) < (getDimension(width: imageWidth, height: imageHeight) - dragTranslation.height) / getDimension(width: imageWidth, height: imageHeight) {
			return (getDimension(width: imageWidth, height: imageHeight) - dragTranslation.width) / getDimension(width: imageWidth, height: imageHeight)
		} else {
			return (getDimension(width: imageWidth, height: imageHeight) - dragTranslation.height) / getDimension(width: imageWidth, height: imageHeight)
		}
	}
}

/// This function just gets the larger of two values, when comparing two inputs.
/// It is typically executed by submitting a width and height of a view to return the larger of the two
func getDimension(width: CGFloat, height: CGFloat) -> CGFloat {
	if height > width {
		return width
	} else {
		return height
	}
}
