//
//  CalculateView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 11/5/2025.
//

import SwiftUI

struct CalculateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var chosen_pkm: PokedexEntry
    @ObservedObject var enemy_pkm: PokedexEntry
    var pkm_level: Int
    var pkm_attack: Int
    @ObservedObject var chosen_move: Move
    @State var damage : Double = 0
    @State var offset: CGFloat = 0
    @State var estimate_opp_hp: Double = 10
    @State var fade_in_opacity: Double = 0.0
    @State var scroll_amt: Double = 0.0
    let animtime: Double = 0.5
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                HStack(alignment: .center, spacing: 30) {
                    PokeView(entry: chosen_pkm, colour: .green)
                        .offset(x: offset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: animtime).delay(0.5)) { offset = 20 }
                            withAnimation(.easeInOut(duration: animtime).delay(0.5 + animtime)) { offset = 0}
                            withAnimation(.easeInOut(duration: animtime).delay(1.0 + animtime)){ fade_in_opacity = 1.0 }
                            withAnimation(.easeInOut(duration: 1.0).delay(1.0 + animtime)){ scroll_amt = 1.0 }
                        }
                    PokeView(entry: enemy_pkm, colour: .red)
                        .offset(x: -offset)
                }
                .padding(.bottom)
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(.green)
                        .frame(width: 300 - (((damage / estimate_opp_hp) * 300) * scroll_amt), height: 10)
                        .opacity(fade_in_opacity)
                        .zIndex(2)
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(.red)
                        .frame(width: 300, height: 10)
                        .opacity(fade_in_opacity)
                        .zIndex(1)
                    
                }
                Text("HP Estimate: \(lround(estimate_opp_hp - damage))/\(Int(estimate_opp_hp))")
                    .opacity(fade_in_opacity)
                HStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.purple)
                        .frame(width: 50, height: 60)
                        .overlay(alignment: .center){
                            Text("⚔️")
                                .font(.system(size: 40))
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.purple)
                        .frame(width: 250, height: 60)
                        .overlay(alignment: .center){
                            Text("Median Damage: " + String(format: "%g", damage))
                        }
                }
                .opacity(fade_in_opacity)
                HStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 60)
                        .overlay(alignment: .center){
                            Text("📉")
                                .font(.system(size: 40))
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.mint)
                        .frame(width: 250, height: 60)
                        .overlay(alignment: .center){
                            Text("Lower Bound: " + String(format: "%g", (damage * 0.85)))
                        }
                    
                }
                .opacity(fade_in_opacity)
                HStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.orange)
                        .frame(width: 50, height: 60)
                        .overlay(alignment: .center){
                            Text("💥")
                                .font(.system(size: 40))
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.orange)
                        .frame(width: 250, height: 60)
                        .overlay(alignment: .center){
                            Text("Upper Bound: " + String(format: "%g", (damage * 1.5)))
                        }
                }
                .opacity(fade_in_opacity)
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
                    // MARK: Enemy HP
                    estimate_opp_hp = 2.0 * Double(enemy_pkm.base!.hp)
                    estimate_opp_hp = estimate_opp_hp * Double(pkm_level)
                    estimate_opp_hp = estimate_opp_hp / 100.0
                    estimate_opp_hp = estimate_opp_hp + 5.0
                })
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Return") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Calculation Result")
            }
        }
    }
}
