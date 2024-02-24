//
//  PhotoListViewModel.swift
//  CachingImages
//
//  Created by Oluwatobi Omotayo on 22/02/2024.
//

import Foundation

@MainActor
class PhotoListViewModel: ObservableObject {
	@Published var photos: [PhotoViewModel]
	
	init(photos: [PhotoViewModel] = []) {
		self.photos = photos
	}
	
	func populatePhotos() async {
		do {
			let photos = try await WebService().getPhotos()
			self.photos = photos.map(PhotoViewModel.init)
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct PhotoViewModel: Identifiable {
	private let photo: Photo
	var id =  UUID()
	
	init(photo: Photo) {
		self.photo = photo
	}
	
	var title: String {
		photo.title
	}
	
	var thumbnailUrl: URL? {
		URL(string: photo.thumbnailUrl)
	}
}
