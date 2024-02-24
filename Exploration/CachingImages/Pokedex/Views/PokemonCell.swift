import SwiftUI

struct PokemonCell: View {
	var pokemon: Pokemon
	
	var body: some View {
		HStack {
			AsyncImage(url: pokemon.url)
			{ image in
				image.resizable()
			} placeholder: {
				Color.secondary.opacity(0.3)
			}
			.frame(width: 120, height: 120)
			PokemonDescriptionView(pokemon: pokemon)
			Spacer()
		}
	}
}
