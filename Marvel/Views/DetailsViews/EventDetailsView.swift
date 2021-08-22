//
//  EventDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct EventDetailsView: View {
    let event: EventInfo
    
    var body: some View {
        ScrollView {
            VStack {
                // Main Information
                mainInfo
                // Characters
                charactersSection
                // Series
                seriesSection
                // Comics
                comicsSection
                // Stories
                storiesSection
                // Creators
                creatorsSection
            }
            
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var mainInfo: some View {
        VStack {
            Image.soobinThumbnail(width: 200, height: 200)
            // title
            Text("Series Title")
            // description
            Text("Description")
            // startYear, endYear, next, previous (if needed)
        }
    }
    
    var charactersSection: some View {
        MarvelSectionView(CharacterFilter(eventId: event.id), title: "Characters", itemWidth: 200)
    }
    
    var seriesSection: some View {
        MarvelSectionView(SeriesFilter(eventId: event.id), title: "Series", rowCount: 2)
    }
    
    var comicsSection: some View {
        MarvelSectionView(ComicFilter(eventId: event.id), title: "Comics", itemWidth: 200)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(eventId: event.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
    
    var creatorsSection: some View {
        MarvelSectionView(CreatorFilter(eventId: event.id), title: "Creators", showsSeeAll: false)
    }
}

//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
