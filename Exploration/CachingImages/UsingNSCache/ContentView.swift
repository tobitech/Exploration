//
//  ContentView.swift
//  CachingImages
//
//  Created by Oluwatobi Omotayo on 22/02/2024.
//

import SwiftUI

struct CachingImagesContentView: View {
	@StateObject var photoListVM = PhotoListViewModel()
	
	var body: some View {
		NavigationStack {
			List(photoListVM.photos) { photo in
				HStack {
					// AsyncImage(url: photo.thumbnailUrl)
					URLImage(url: photo.thumbnailUrl)
					Text(photo.title)
				}
			}
			.task {
				await photoListVM.populatePhotos()
			}
			.navigationTitle("Photos")
		}
	}
}

#Preview {
	CachingImagesContentView()
}
