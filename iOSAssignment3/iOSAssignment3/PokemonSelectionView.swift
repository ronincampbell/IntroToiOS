//
//  PokemonSelectionView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 10/5/2025.
//

import SwiftUI


struct PokemonSelectionView: View {
    let onSelect: (PokedexEntry) -> Void
    let title: String

    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var filteredEntries: [PokedexEntry] {
        allPokedexEntries
            .filter { (searchText.isEmpty || $0.name.english.localizedCaseInsensitiveContains(searchText)) && $0.base != nil }
            .sorted { $0.id < $1.id }
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
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PokemonSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSelectionView(onSelect: {_ in}, title: "Preview Window")
    }
}
