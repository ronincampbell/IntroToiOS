//
//  MoveListView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 10/5/2025.
//

import SwiftUI

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

struct MoveListView_Previews: PreviewProvider {
    static var previews: some View {
        MoveListView(pokemonName: "Bulbasaur")
    }
}
