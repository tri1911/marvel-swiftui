//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    // Overview
                    StandardSectionView(Array(0..<5), id: \.self) { _ in
                        CardView5()
                    }
                    
                    // Categories
                    VStack {
                        Divider().padding(.horizontal)
                        StandardHeaderView<AnyView>(title: "Categories").padding(.horizontal)
                        StandardSectionView(Category.categories, id: \.self) {
                            CategoryCardView(category: $0)
                        }
                    }
                    
                    // Characters
                    MarvelSectionView(CharacterFilter(orderBy: "-modified"), title: "Characters", itemWidth: 165)
                    
                    // Comics
                    MarvelSectionView(ComicFilter(orderBy: "-modified"), title: "Newest Comics", itemWidth: 250)
                    
                    // Events
                    MarvelSectionView(EventFilter(orderBy: "-modified"), title: "Incoming Events", rowCount: 3)
                    
                    // Series
                    MarvelSectionView(SeriesFilter(orderBy: "-modified"), title: "New Release Series", rowCount: 2)
                    
                    // Stories
                    MarvelSectionView(StoryFilter(orderBy: "-modified"), title: "Newest Stories", showsSeeAll: false, itemHeight: 300)
                    
                    // Creators
                    MarvelSectionView(CreatorFilter(orderBy: "-modified"), title: "Popular Creators", showsSeeAll: false)
                }
            }
            .navigationTitle("Marvel")
        }
    }
}

enum Category: String, CaseIterable, Identifiable {
    case characters, comics, events, series, stories, creators
    var id: Category { self }
    var title: String { self.rawValue.capitalized }
    static var categories: [String] { Category.allCases.map { $0.rawValue.capitalized } }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
    }
}
