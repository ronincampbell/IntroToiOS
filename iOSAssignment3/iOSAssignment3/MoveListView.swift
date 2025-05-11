//
//  MoveListView.swift
//  iOSAssignment3
//
//  Created by Brad Hoy on 10/5/2025.
//

import SwiftUI

struct MoveListView: View {
    @Binding var chosen_move: Move?
    @State var query: String = ""
    @State var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    var filteredMoves: [Move] {
        allMoves
            .filter { (searchText.isEmpty || $0.ename.localizedCaseInsensitiveContains(searchText)) && $0.power != nil }
            .sorted { $0.id < $1.id }
    }
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Moves", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                
                ScrollView {
                    ForEach(filteredMoves) { move in
                        Button(action: {chosen_move = move;dismiss()}){
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .frame(minHeight: 50)
                                .foregroundColor(.blue)
                                .overlay(alignment: .center){
                                    VStack(alignment: .center){
                                        Text(move.ename)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(move.type)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                }
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Move Select")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MoveListView_Previews: PreviewProvider {
    static var previews: some View {
        MoveListView(chosen_move: .constant(Move(id: 1, ename: "Pound", type: "Normal", power: 40)))
    }
}
