//
//  FavouritesView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-23.
//

import SwiftUI
import CoreData

struct FavouritesView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(fetchRequest: Character.fetchRequest(.all)) var characters: FetchedResults<Character>
    
    var body: some View {
        if characters.isEmpty {
            Text("No characters")
        } else {
            List {
                ForEach(characters
                ) { character in
                    HStack {
                        Text(character.name)
                        Spacer()
                        Image(systemName: "trash")
                            .onTapGesture {
                                Character.delete(character, context: context)
                            }
                    }
                }
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
