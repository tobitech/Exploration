//
//  CameraControlView.swift
//  Exploration
//
//  Created by Oluwatobi Omotayo on 14/09/2024.
//

import SwiftUI

struct CameraControlView: View {
	@State var value: CGFloat = 1
	
	var body: some View {
		MeshingSlider(
			value: $value,
			colors: [
				.yellow,
				.orange,
				.pink,
				.purple
			]
		)
	}
}

#Preview {
	CameraControlView()
}
