//
//  PokemonBattleCalculatorView.swift
//  iOSAssignment3
//
//  Created by Ronin Campbell on 7/5/2025.
//

import SwiftUI

struct PokemonBattleCalculatorView: View {
    @State private var selectedPokemon1: String? = nil
    @State private var selectedPokemon2: String? = nil
    @State private var showingSelectorForFirst = false
    @State private var showingSelectorForSecond = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    SelectionButton(title: selectedPokemon1 ?? "Select Pokémon 1") {
                        showingSelectorForFirst = true
                    }
                    SelectionButton(title: selectedPokemon2 ?? "Select Pokémon 2") {
                        showingSelectorForSecond = true
                    }
                }
                .padding(.top)

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    if let p1 = selectedPokemon1 {
                        Text("\(p1) Moves")
                            .font(.headline)
                        ForEach(0..<4) { index in
                            MoveRow(moveName: "Move \(index + 1)", damageText: "-- dmg")
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    if let p2 = selectedPokemon2 {
                        Text("\(p2) Moves")
                            .font(.headline)
                        ForEach(0..<4) { index in
                            MoveRow(moveName: "Move \(index + 1)", damageText: "-- dmg")
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Battle Calculator")
            .sheet(isPresented: $showingSelectorForFirst) {
                PokemonSelectionView(gen1Pokemon: gen1Pokemon, onSelect: { name in
                    selectedPokemon1 = name
                    showingSelectorForFirst = false
                }, title: "Select Pokémon 1")
            }
            .sheet(isPresented: $showingSelectorForSecond) {
                PokemonSelectionView(gen1Pokemon: gen1Pokemon, onSelect: { name in
                    selectedPokemon2 = name
                    showingSelectorForSecond = false
                }, title: "Select Pokémon 2")
            }
        }
    }

    // Sample Gen 1 list
    let gen1Pokemon = ["Bulbasaur", "Charmander", "Squirtle", "Pikachu", "Eevee", "Jigglypuff", "Meowth", "Psyduck", "Snorlax", "Mewtwo"]
}

// Button styled for selection
struct SelectionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(width: 140, height: 140)
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}

// Row for move display
struct MoveRow: View {
    let moveName: String
    let damageText: String

    var body: some View {
        HStack {
            Text(moveName)
            Spacer()
            Text(damageText)
                .foregroundColor(.secondary)
        }
    }
}

// Pokémon selection screen
struct PokemonSelectionView: View {
    let gen1Pokemon: [String]
    let onSelect: (String) -> Void
    let title: String

    @State private var searchText: String = ""

    // Filtered list
    var filteredList: [String] {
        if searchText.isEmpty {
            return gen1Pokemon
        } else {
            return gen1Pokemon.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // Grid layout
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 16)]

    var body: some View {
        NavigationView {
            VStack {
                // Search box
                TextField("Search Pokémon", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredList, id: \.self) { name in
                            VStack {
                                // Placeholder for sprite
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Text("🖼️")
                                    )
                                Text(name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                onSelect(name)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onSelect("")
                    }
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
