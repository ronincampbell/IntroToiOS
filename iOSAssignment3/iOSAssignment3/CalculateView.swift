//
//  CalculateView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 11/5/2025.
//

import SwiftUI

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

struct CalculateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var chosen_pkm: PokedexEntry
    @ObservedObject var enemy_pkm: PokedexEntry
    var pkm_level: Int
    var pkm_attack: Int
    @ObservedObject var chosen_move: Move
    @State var damage : Double = 0
    var body: some View {
        NavigationView{
            VStack{
                Text("Median Damage: \(damage)")
                    .onAppear(perform: {
                        var defense: Double
                        if (physical_moves.contains(chosen_move.type)){
                            defense = Double(chosen_pkm.base!.defense)
                            defense = defense + (Double(chosen_pkm.base!.defense) * 0.02 * Double(pkm_level))
                        }else{
                            defense = Double(enemy_pkm.base!.special_defense)
                            defense = defense + (Double(enemy_pkm.base!.special_defense) * 0.02 * Double(pkm_level))
                        }
                        damage = Double(pkm_level) * 2
                        damage = damage / 5
                        damage = damage + 2
                        damage = damage * Double(chosen_move.power!)
                        damage = damage * (Double(pkm_attack) / defense)
                        damage = damage / 50
                        damage = damage + 2
                        // MARK: Type effectiveness
                        for i in allTypes{
                            if (i.english == chosen_move.type){
                                for j in enemy_pkm.type{
                                    if (i.effective.contains(j)){
                                        damage = damage * 2
                                    }else if (i.inaffective.contains(j)){
                                        damage = damage / 2
                                    }else if (i.no_effect.contains(j)){
                                        damage = 0
                                    }
                                }
                                break
                            }
                        }
                        // MARK: STAB
                        if (chosen_pkm.type.contains(chosen_move.type)){
                            damage = damage * 1.5
                        }
                    })
                Text("Lower Bound: \(damage * 0.85)")
                Text("Upper Bound: \(damage * 1.5)")
            }
            .navigationTitle("Calculation Result")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Return") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/*struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateView(chosen_pkm: .constant(PokedexEntry(id: 1, name: Name(english: "Bulbasaur"), image: ImageURLs(sprite: "https://raw.githubusercontent.com/Purukitto/pokemon-data.json/master/images/pokedex/sprites/001.png"), base: BaseStats(hp: 45, attack: 49, defense: 49, special_attack: 65, special_defense: 65, speed: 45))), enemy_pkm: .constant(PokedexEntry(id: 1, name: Name(english: "Bulbasaur"), image: ImageURLs(sprite: "https://raw.githubusercontent.com/Purukitto/pokemon-data.json/master/images/pokedex/sprites/001.png"), base: BaseStats(hp: 45, attack: 49, defense: 49, special_attack: 65, special_defense: 65, speed: 45))), pkm_level: 50, pkm_attack: 20, chosen_move: .constant(Move(id: 1, ename: "Pound", type: "Normal", power: 40)))
    }
}*/
