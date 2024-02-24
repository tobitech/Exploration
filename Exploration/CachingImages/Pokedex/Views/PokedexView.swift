import SwiftUI

struct PokedexView: View {
	@StateObject private var loader = PokemonLoader()
	
	var body: some View {
		NavigationStack {
			PokemonList(loader: loader)
				.navigationTitle("PokeDex")
				.task {
					await loader.load(restart: true)
				}
				.refreshable {
					// Enable pull to refresh
					await loader.load(restart: true)
				}
		}
	}
}

#Preview {
	PokedexView()
}
