//
//  SeriesDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct SeriesDetailsView: View {
    let series: SeriesInfo
    
    var body: some View {
        ScrollView {
            VStack {
                mainInfo
                comicsSection
                charactersSection
                storiesSection
                eventsSection
                creatorsSection
            }
        }
        .navigationTitle(series.title)
    }
    
    var mainInfo: some View {
        VStack {
            // title
            Text("Series Title")
            // description (almost null)
            Text("Description")
            // urls
            Text("URLs")
            // startYear, endYear, rating, next, previous (if needed)
        }
    }
    
    var comicsSection: some View {
        MarvelSectionView(ComicFilter(seriesId: series.id), title: "Comics", itemWidth: 200)
    }
    
    var charactersSection: some View {
        MarvelSectionView(CharacterFilter(seriesId: series.id), title: "Characters", itemWidth: 165)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(seriesId: series.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
    
    var eventsSection: some View {
        MarvelSectionView(EventFilter(seriesId: series.id), title: "Events", rowCount: 3)
    }
    
    var creatorsSection: some View {
        MarvelSectionView(CreatorFilter(seriesId: series.id), title: "Creators", showsSeeAll: false)
    }
}
