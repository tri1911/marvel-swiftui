//
//  CreatorDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct CreatorDetailsView: View {
    @EnvironmentObject var store: MarvelStore
    
    let creator: CreatorInfo
    
    // MARK: - Filters
    
    let comicFilter: ComicFilter
    let seriesFilter: SeriesFilter
    let eventFilter: EventFilter
    let storyFilter: StoryFilter
    
    init(_ creator: CreatorInfo) {
        self.creator = creator
        comicFilter = ComicFilter(creatorId: creator.id)
        seriesFilter = SeriesFilter(creatorId: creator.id)
        eventFilter = EventFilter(creatorId: creator.id)
        storyFilter = StoryFilter(creatorId: creator.id)
    }
    
    var comics: [ComicInfo]? { store.comics[comicFilter] }
    var series: [SeriesInfo]? { store.series[seriesFilter] }
    var events: [EventInfo]? { store.events[eventFilter] }
    var stories: [StoryInfo]? { store.stories[storyFilter] }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // Comics
                comicsSection
                // Series
                seriesSection
                // Events
                eventsSection
                // Stories
                storiesSection
                Spacer()
            }
        }
        .navigationTitle(creator.fullName)
        .onAppear {
            store.fetch(comicFilter)
            store.fetch(seriesFilter)
            store.fetch(eventFilter)
            store.fetch(storyFilter)
        }
    }
    
    var comicsSection: some View {
        StandardSectionView(comics, title: "Comics", destination: Text("All Comics")) { comic in
            CardView2(title: comic.title, description: comic.description_)
                .frame(width: 200)
        }
    }
    
    var seriesSection: some View {
        StandardSectionView(series, title: "Series", destination: Text("All Series")) { series in
            CardView2(title: series.title, description: series.description_)
                .frame(width: 200)
        }
    }
    
    var eventsSection: some View {
        StandardSectionView(events, title: "Events", destination: Text("All Events")) { event in
            CardView2(title: event.title, description: event.description_)
                .frame(width: 200)
        }
    }
    
    var storiesSection: some View {
        StandardSectionView(stories, title: "Stories", destination: Text("All Stories")) { story in
            CardView2(title: story.title, description: story.description_)
                .frame(width: 200)
        }
    }
}

//struct CreatorDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorDetailsView()
//    }
//}
