//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct HomeView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    // Overview
                    FeaturedComicsView(ComicFilter(formatType: .comic, dateDescriptor: .thisMonth, startYear: 2021, orderBy: "issueNumber"))
                    
                    // Categories
                    CategoriesSectionView(tabSelection: $tabSelection)
                    
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(tabSelection: .constant(1))
            .previewLayout(.sizeThatFits)
    }
}
