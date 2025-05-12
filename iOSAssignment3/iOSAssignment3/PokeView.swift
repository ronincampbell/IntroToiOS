//
//  PokeView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 12/5/2025.
//

import SwiftUI

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
