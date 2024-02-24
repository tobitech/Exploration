//
//  WebService.swift
//  CachingImages
//
//  Created by Oluwatobi Omotayo on 22/02/2024.
//

import Foundation

extension String: Error {}

class WebService {
	func getPhotos() async throws -> [Photo] {
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
			throw "Invalid URL"
		}
		let (data, response) = try await URLSession.shared.data(from: url)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw "Status Code Error"
		}
		
		return try JSONDecoder().decode([Photo].self, from: data)
	}
}
