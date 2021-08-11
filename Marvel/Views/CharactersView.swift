//
//  CharactersView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI

struct CharactersView: View {
    @EnvironmentObject var store: CharacterStore
    
    @State private var search = CharacterFilterSet()
    
    var characters: Set<CharacterInfo>? { store.characters[search] }
    
    var body: some View {
        NavigationView {
            List {
                if let characters = characters {
                    ForEach(Array(characters)) { character in
                        Text(character.name)
                    }
                    Text("Count=\(characters.count)")
                } else {
                    Text("Nothing")
                }
            }
            .navigationTitle(search.nameStartsWith ?? "Unknown")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Search for Spider") {
                        search = CharacterFilterSet(nameStartsWith: "Spider")
                        store.fetch(search)
                    }
                    
                    Spacer()
                    
                    Button("Search for Thor") {
                        search = CharacterFilterSet(nameStartsWith: "Thor")
                        store.fetch(search)
                    }
                }
            }
            
        }
        .onAppear {
            store.fetch(search)
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
