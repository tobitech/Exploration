// Reference - https://youtu.be/KhGyiOk3Yzk?si=IL2M2E0zOPHwWEIt

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
