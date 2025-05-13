//
//  SelectInfoView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 10/5/2025.
//

import SwiftUI


struct SelectInfoView: View {
    @ObservedObject var chosen_pkm: PokedexEntry
    @ObservedObject var enemy_pkm: PokedexEntry
    @State var pkm_level: Int = 50
    @State var pkm_attack: Int = 20
    @State var show_moves: Bool = false
    @State var chosen_move: Move? = nil
    @State var show_calculation: Bool = false
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .center){
                Text("Pokémon Level")
                    .multilineTextAlignment(.center)
                TextField("Level", value: $pkm_level, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
            }
            .padding(.leading)
            .padding(.trailing)
            Spacer()
            Button(action: {show_moves = true}){
                if (chosen_move != nil){
                    Text("Selected Move: " + chosen_move!.ename)
                        .multilineTextAlignment(.center)
                }else{
                    Text("Select Move")
                }
            }
            .sheet(isPresented: $show_moves){
                MoveListView(chosen_move: $chosen_move)
            }
            Spacer()
            VStack(alignment: .center){
                if (chosen_move == nil || physical_moves.contains(chosen_move!.type)){
                    Text("Attack IV")
                        .multilineTextAlignment(.center)
                }else{
                    Text("Special Attack IV")
                        .multilineTextAlignment(.center)
                }
                TextField("IV", value: $pkm_attack, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
            }
            .padding(.leading)
            .padding(.trailing)
            
        }
        Spacer()
        Button(action: {if (chosen_move != nil){show_calculation = true}}){
            RoundedRectangle(cornerRadius: 25)
                .fill(chosen_move == nil ? .red : .green)
        }
        .frame(maxHeight: 200)
        .overlay(alignment: .center){
            if (chosen_move != nil){
                Text("Calculate Damage")
                    .foregroundStyle(.white)
            }else{
                Text("Information Missing")
                    .foregroundStyle(.white)
            }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        .sheet(isPresented: $show_calculation){
            CalculateView(chosen_pkm: chosen_pkm, enemy_pkm: enemy_pkm, pkm_level: pkm_level, pkm_attack: pkm_attack, chosen_move: chosen_move!)
        }
    }
}
