//
//  Move.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 12/5/2025.
//

import Foundation

class Move: Decodable, Identifiable, ObservableObject {
    let id: Int
    let ename: String
    let type: String
    let power: Int?
    init(id: Int, ename: String, type: String, power: Int?) {
        self.id = id
        self.ename = ename
        self.type = type
        self.power = power
    }
}

let allMoves: [Move] = {
    guard let url = Bundle.main.url(forResource: "moves", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let entries = try? JSONDecoder().decode([Move].self, from: data) else {
        return []
    }
    return entries.sorted { $0.id < $1.id }
}()

let physical_moves: [String] = ["Normal", "Fighting", "Rock", "Ground", "Flying", "Poison", "Bug", "Ghost", "Steel"]
