import SwiftUI

struct PokemonCell: View {
	let pokemon: Pokemon
	private let imageWidth = 110.0
	private let cellHeight = 130.0
	
	var body: some View {
		HStack {
			CacheAsyncImage(url: pokemon.url) { phase in
				switch phase {
				case let .success(image):
					HStack {
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: imageWidth)
							.padding(.trailing, 10)
						PokemonDescriptionView(pokemon: pokemon)
						Spacer()
					}
				case let .failure(error):
					ErrorView(error: error)
				case .empty:
					HStack {
						ProgressView()
							.progressViewStyle(.circular)
							.tint(.red)
						Spacer()
					}
				@unknown default:
					Image(systemName: "questionmark")
				}
			}
		}
	}
}
