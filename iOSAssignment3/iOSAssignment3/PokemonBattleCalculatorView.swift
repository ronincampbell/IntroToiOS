//
//  PokemonBattleCalculatorView.swift
//  iOSAssignment3
//
//  Created by Ronin Campbell on 7/5/2025.
//

import SwiftUI

// MARK: - Main Calculator View
struct PokemonBattleCalculatorView: View {
    @State private var selectedPokemon1: PokedexEntry? = nil
    @State private var selectedPokemon2: PokedexEntry? = nil
    @State private var showingSelectorForFirst = false
    @State private var showingSelectorForSecond = false

    var body: some View {
        //NavigationView {
            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 30) {
                    SelectionBox(entry: selectedPokemon1,
                                 placeholder: "1",
                                 action: { showingSelectorForFirst = true })
                    SelectionBox(entry: selectedPokemon2,
                                 placeholder: "2",
                                 action: { showingSelectorForSecond = true })
                }
                .padding(.top)

                Spacer()

                if (selectedPokemon1 != nil && selectedPokemon2 != nil){
                    SelectInfoView(chosen_pkm: selectedPokemon1!, enemy_pkm: selectedPokemon2!)
                }

                Spacer()
            }
            .navigationTitle("Battle Calculator")
            .sheet(isPresented: $showingSelectorForFirst) {
                PokemonSelectionView(
                    onSelect: { entry in
                        selectedPokemon1 = entry
                        showingSelectorForFirst = false
                    },
                    title: "Select Pokémon 1"
                )
            }
            .sheet(isPresented: $showingSelectorForSecond) {
                PokemonSelectionView(
                    onSelect: { entry in
                        selectedPokemon2 = entry
                        showingSelectorForSecond = false
                    },
                    title: "Select Pokémon 2"
                )
            }
       // }
    }
}


struct PokemonBattleCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBattleCalculatorView()
    }
}
