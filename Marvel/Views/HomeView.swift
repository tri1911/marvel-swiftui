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
    
    var characters: [CharacterInfo]? { store.characters[characterFilterSet] }
    var comics: [ComicInfo]? { store.comics[comicFilterSet] }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    // Overview
                    SectionDemoView1()
                    
                    // Categories
                    SectionDemoView2(Category.allCases.map { $0.rawValue.capitalized }, title: "Categories")
                    
                    // New Characters
                    StandardSectionView(characters, title: "Newest Characters", destination: SeeAllDemoView1(characters ?? [], titleKey: \.name, descriptionKey: \.description)) { character in
                        NavigationLink(destination: CharacterDetailsView(character)) {
                            CardView1(type: "Character", title: character.name, description: character.description, modified: character.modified_)
                        }
                    }
                    
                    //  New Comics
                    StandardSectionView(comics, title: "Newest Comics", destination: SeeAllDemoView2(comics ?? [], titleKey: \.title, descriptionKey: \.description_)) { comic in
                        NavigationLink(destination: ComicDetailsView(comic)) {
                            CardView2(title: comic.title, description: comic.description_)
                                .frame(width: 165)
                        }
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
