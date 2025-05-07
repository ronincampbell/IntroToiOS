//
//  PokemonBattleCalculatorView.swift
//  iOSAssignment3
//
//  Created by Ronin Campbell on 7/5/2025.
//

import SwiftUI

// MARK: - Pokedex Model
struct PokedexEntry: Decodable, Identifiable {
    let id: Int
    struct Name: Decodable { let english: String }
    let name: Name
    struct ImageURLs: Decodable { let sprite: String }
    let image: ImageURLs
}

// Load and sort all entries from pokedex.json in the bundle
let allPokedexEntries: [PokedexEntry] = {
    guard let url = Bundle.main.url(forResource: "pokedex", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let entries = try? JSONDecoder().decode([PokedexEntry].self, from: data) else {
        return []
    }
    return entries.sorted { $0.id < $1.id }
}()

// MARK: - Main Calculator View
struct PokemonBattleCalculatorView: View {
    @State private var selectedPokemon1: PokedexEntry? = nil
    @State private var selectedPokemon2: PokedexEntry? = nil
    @State private var showingSelectorForFirst = false
    @State private var showingSelectorForSecond = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    SelectionBox(entry: selectedPokemon1,
                                 placeholder: "1",
                                 action: { showingSelectorForFirst = true })
                    SelectionBox(entry: selectedPokemon2,
                                 placeholder: "2",
                                 action: { showingSelectorForSecond = true })
                }
                .padding(.top)

                Spacer()

                if let p1 = selectedPokemon1 {
                    MoveListView(pokemonName: p1.name.english)
                }
                if let p2 = selectedPokemon2 {
                    MoveListView(pokemonName: p2.name.english)
                }

                Spacer()
            }
            .navigationTitle("Battle Calculator")
            .sheet(isPresented: $showingSelectorForFirst) {
                PokemonSelectionView(
                    entries: allPokedexEntries,
                    onSelect: { entry in
                        selectedPokemon1 = entry
                        showingSelectorForFirst = false
                    },
                    title: "Select Pokémon 1"
                )
            }
            .sheet(isPresented: $showingSelectorForSecond) {
                PokemonSelectionView(
                    entries: allPokedexEntries,
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
        }
    }
}

// MARK: - Move List Placeholder
struct MoveListView: View {
    let pokemonName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(pokemonName) Moves")
                .font(.headline)
            ForEach(0..<4) { idx in
                HStack {
                    Text("Move \(idx+1)")
                    Spacer()
                    Text("-- dmg")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

// MARK: - Pokémon Selection Screen
struct PokemonSelectionView: View {
    let entries: [PokedexEntry]
    let onSelect: (PokedexEntry) -> Void
    let title: String

    @State private var searchText: String = ""

    var filteredEntries: [PokedexEntry] {
        let list = entries.filter { entry in
            searchText.isEmpty || entry.name.english.localizedCaseInsensitiveContains(searchText)
        }
        return list.sorted { $0.id < $1.id }
    }

    let columns = [GridItem(.adaptive(minimum: 80), spacing: 16)]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Pokémon", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredEntries) { entry in
                            VStack {
                                AsyncImage(url: URL(string: entry.image.sprite)) { phase in
                                    if let img = phase.image {
                                        img
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    } else if phase.error != nil {
                                        Color.red.frame(width: 80, height: 80)
                                    } else {
                                        Color.gray.opacity(0.3)
                                            .frame(width: 80, height: 80)
                                    }
                                }
                                Text(entry.name.english)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                onSelect(entry)
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
                        onSelect(entries.first!)
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
