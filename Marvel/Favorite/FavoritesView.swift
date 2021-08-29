//
//  FavoritesView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(fetchRequest: Character.fetchRequest(.all)) var characters: FetchedResults<Character>
    @FetchRequest(fetchRequest: Comic.fetchRequest(.all)) var comics: FetchedResults<Comic>
    @FetchRequest(fetchRequest: Series.fetchRequest(.all)) var series: FetchedResults<Series>
    
    enum FavoriteContent: String, CaseIterable, Identifiable {
        case characters
        case comics
        case series
        
        var id: String { self.rawValue }
    }
    
    @State private var selectedContent: FavoriteContent = .characters
    
    var body: some View {
        NavigationView {
            VStack {
                switch selectedContent {
                case .characters:
                    characterPage
                case .comics:
                    comicPage
                case .series:
                    seriesPage
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Favorite Content", selection: $selectedContent) {
                        ForEach(FavoriteContent.allCases) { content in
                            Text(content.rawValue.capitalized).tag(content)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
    
    @ViewBuilder
    var characterPage: some View {
        if characters.isEmpty {
            Text("No Characters")
        } else {
            ScrollView {
                StandardGridView(items: Array(characters)) { character in
                    CharacterCardView(character.toCharacterInfo())
                }
            }
//            .transition(.slide)
//            .animation(.default)
        }
    }
    
    @ViewBuilder
    var comicPage: some View {
        if comics.isEmpty {
            Text("No Comics")
        } else {
            ScrollView {
                StandardGridView(items: Array(comics)) { comic in
                    ComicCardView(comic.toComicInfo())
                }
            }
        }
    }
    
    @ViewBuilder
    var seriesPage: some View {
        if series.isEmpty {
            Text("No Series")
        } else {
            ScrollView {
                StandardVerticalStackView(items: Array(series)) {
                    SeriesCardView($0.toSeriesInfo())
                }
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
