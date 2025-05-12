//
//  PokedexEntry.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 12/5/2025.
//

import Foundation


struct BaseStats: Decodable{
    let hp: Int
    let attack: Int
    let defense: Int
    let special_attack: Int
    let special_defense: Int
    let speed: Int
    enum CodingKeys: String, CodingKey {
        case hp = "HP"
        case attack = "Attack"
        case defense = "Defense"
        case special_attack = "Sp. Attack"
        case special_defense = "Sp. Defense"
        case speed = "Speed"
    }
}

struct Name: Decodable {
    let english: String
}

struct ImageURLs: Decodable {
    let sprite: String
}

class PokedexEntry: Decodable, Identifiable, ObservableObject {
    let id: Int
    let name: Name
    let image: ImageURLs
    let base: BaseStats?
    let type: [String]
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
