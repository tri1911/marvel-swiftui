//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Store Object(s)
    
    @EnvironmentObject var store: MarvelStore
    
    // MARK: - Filter Set(s)
    
    private let characterFilterSet = CharacterFilter(orderBy: "-modified")
    private let comicFilterSet = ComicFilter(orderBy: "-modified")
    
    // MARK: - Fetched Results
    
    var characters: [CharacterInfo] { store.characters[characterFilterSet] ?? [] }
    var comics: [ComicInfo] { store.comics[comicFilterSet] ?? [] }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    // Overview
                    SectionDemoView1()
                    // Categories on the top
                    SectionDemoView2(Category.allCases.map { $0.rawValue.capitalized }, title: "Categories")
                    // Featured Characters
                    StandardSectionView(characters, title: "Newest Characters") { character in
                        CardView1(type: "Character", title: character.name, description: character.description, modified: character.modifiedDate)
                    }
                    //  Featured Comics
                    StandardSectionView(comics, title: "Newest Comics") { comic in
                        CardView2(title: comic.title, description: comic.description)
                            .frame(width: 165)
                    }
                    //  Featured Events
                    //  Featured Series
                    //  Featured Stories
                    //  Featured Creators
                }
            }
            .navigationTitle("Marvel")
            .onAppear {
                store.fetch(characterFilterSet)
                store.fetch(comicFilterSet)
            }
        }
    }
}

enum Category: String, CaseIterable {
    case characters, comics, events, series, stories, creators
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
    }
}
