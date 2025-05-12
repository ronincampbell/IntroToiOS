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
        NavigationView {
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
        }
    }
}

// MARK: - Selection Box
struct SelectionBox: View {
    let entry: PokedexEntry?
    let placeholder: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .center){
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 140, height: 140)
                    if let entry = entry, let url = URL(string: entry.image.sprite) {
                        AsyncImage(url: url) { phase in
                            if let img = phase.image {
                                img
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else if phase.error != nil {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                            } else {
                                ProgressView()
                            }
                        }
                    } else {
                        Text("Select \(placeholder)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                if (entry != nil){
                    Text(entry!.name.english)
                        .font(.subheadline)
                }else{
                    Text("")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct PokemonBattleCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBattleCalculatorView()
    }
}
