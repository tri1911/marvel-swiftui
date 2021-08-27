//
//  CharactersView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI
import Combine

struct CharactersView: View {
    let request = CharacterInfoRequest.create(CharacterFilter(orderBy: "name"))
    
    @State private var characters = [CharacterInfo]()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // TODO: Load More when scrolling to the bottom of the list
            // List of characters by name
            StandardGridView(items: characters) {
                CharacterCardView($0)
            }
            .onReceive(request.results) { results in
                characters = results
            }
        }
        .navigationTitle("Characters")
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
