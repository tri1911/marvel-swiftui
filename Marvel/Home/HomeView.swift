//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct HomeView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    // Featured Comics
                    FeaturedComicsSectionView(ComicFilter(formatType: .comic, dateDescriptor: .thisMonth, startYear: 2021, orderBy: "issueNumber"))
                    // Categories
                    CategoriesSectionView(tabSelection: $tabSelection)
                    // Characters
                    MarvelSectionView(CharacterFilter(orderBy: "-modified"), offset: 70, title: "Featured Characters", itemWidth: 165)
                    // Comics
                    MarvelSectionView(ComicFilter(format: .comic, formatType: .comic, orderBy: "-focDate"), title: "New Comics", itemWidth: 250)
                    // Events
                    MarvelSectionView(EventFilter(orderBy: "-modified"), title: "Incoming Events", rowCount: 3)
                    // Series
                    MarvelSectionView(SeriesFilter(seriesType: .limited), offset: 80, title: "Most Popular Series", rowCount: 2)
                    // Stories
                    MarvelSectionView(StoryFilter(orderBy: "-modified"), title: "Recently Modified Stories", showsSeeAll: false, itemHeight: 300)
                    // Creators
                    MarvelSectionView(CreatorFilter(eventId: 310), title: "Popular Creators", showsSeeAll: false)
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
