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
    @State var offset: CGFloat = 0
    let animtime: Double = 0.5
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                HStack(alignment: .center, spacing: 30) {
                    PokeView(entry: chosen_pkm, colour: .green)
                        .offset(x: offset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: animtime).delay(0.5)) { offset = 20 }
                            withAnimation(.easeInOut(duration: animtime).delay(0.5 + animtime)) { offset = 0 }
                        }
                    PokeView(entry: enemy_pkm, colour: .red)
                        .offset(x: -offset)
                }
                .padding(.bottom)
                HStack{
                    Text("Median Damage: \(damage)")
                }
                HStack{
                    Text("Lower Bound: \(damage * 0.85)")
                }
                HStack{
                    Text("Upper Bound: \(damage * 1.5)")
                }
                .navigationTitle("Calculation Result")
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
}
    
struct PokeView: View{
    let entry: PokedexEntry
    let colour: Color
    var body: some View{
        VStack(alignment: .center){
            ZStack {
                Circle()
                    .strokeBorder(.gray, lineWidth: 5)
                    .background(Circle().fill(colour))
                    .frame(width: 100, height: 100)
                    
                if let url = URL(string: entry.image.sprite) {
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
                    .drawingGroup()
                }
            }
            Text(entry.name.english)
                .font(.subheadline)
        }
        
    }
}
