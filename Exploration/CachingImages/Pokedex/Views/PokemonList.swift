import SwiftUI

struct PokemonList: View {
	@ObservedObject var loader: PokemonLoader
	
	init(loader: PokemonLoader) {
		self.loader = loader
	}
	
	var body: some View {
		List {
			ForEach(loader.pokemonData) { pokemon in
				PokemonCell(pokemon: pokemon)
					.task {
						if pokemon == loader.pokemonData.last {
							await loader.load()
						}
					}
			}
		}
	}
}
