//
//  SelectionBox.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 12/5/2025.
//

import SwiftUI

struct SelectionBox: View {
    let entry: PokedexEntry?
    let placeholder: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .center){
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 140, height: 140)
                    if let entry = entry, let url = URL(string: entry.image.sprite) {
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
                    } else {
                        Text("Select \(placeholder)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                if (entry != nil){
                    Text(entry!.name.english)
                        .font(.subheadline)
                }else{
                    Text("")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
