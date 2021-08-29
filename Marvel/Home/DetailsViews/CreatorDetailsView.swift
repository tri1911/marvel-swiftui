//
//  CreatorDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct CreatorDetailsView: View {    
    let creator: CreatorInfo
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                comicsSection
                seriesSection
                eventsSection
                storiesSection
                Spacer()
            }
        }
        .navigationTitle(creator.fullName)
    }
    
    var comicsSection: some View {
        MarvelSectionView(ComicFilter(creatorId: creator.id), title: "Comics", itemWidth: 200)
    }
    
    var seriesSection: some View {
        MarvelSectionView(SeriesFilter(creatorId: creator.id), title: "Series", rowCount: 2)
    }
    
    var eventsSection: some View {
        MarvelSectionView(EventFilter(creatorId: creator.id), title: "Events", rowCount: 3)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(creatorId: creator.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
}
