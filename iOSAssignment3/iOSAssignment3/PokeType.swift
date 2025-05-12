//
//  PokeType.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 12/5/2025.
//

import Foundation
struct PokeType: Decodable{
    let english: String
    let effective: [String]
    let inaffective: [String]
    let no_effect: [String]
    
}

let allTypes: [PokeType] = {
    guard let url = Bundle.main.url(forResource: "types", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let entries = try? JSONDecoder().decode([PokeType].self, from: data) else {
        return []
    }
    return entries
}()
