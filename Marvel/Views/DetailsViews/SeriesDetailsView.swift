//
//  SeriesDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct SeriesDetailsView: View {
    @EnvironmentObject var store: MarvelStore
    
    let series: SeriesInfo
    
    // MARK: - Filters
    
    let comicFilter: ComicFilter
    let storyFilter: StoryFilter
    let eventFilter: EventFilter
    let creatorFilter: CreatorFilter
    let characterFilter: CharacterFilter
    
    var comics: [ComicInfo]? { store.comics[comicFilter] }
    var stories: [StoryInfo]? { store.stories[storyFilter] }
    var events: [EventInfo]? { store.events[eventFilter] }
    var creators: [CreatorInfo]? { store.creators[creatorFilter] }
    var characters: [CharacterInfo]? { store.characters[characterFilter] }
    
    init(_ series: SeriesInfo) {
        self.series = series
        self.comicFilter = ComicFilter(seriesId: series.id)
        self.storyFilter = StoryFilter(seriesId: series.id)
        self.eventFilter = EventFilter(seriesId: series.id)
        self.creatorFilter = CreatorFilter(seriesId: series.id)
        self.characterFilter = CharacterFilter(seriesId: series.id)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Main information
                mainInfo
                // Comics
                comicsSection
                // Stories
                storiesSection
                // Events
                eventsSection
                // Characters
                charactersSection
                // Creators
                creatorsSection
            }
        }
        .navigationTitle(series.title)
        .onAppear {
            store.fetch(comicFilter)
            store.fetch(storyFilter)
            store.fetch(eventFilter)
            store.fetch(creatorFilter)
            store.fetch(characterFilter)
        }
    }
    
    var mainInfo: some View {
        VStack {
            // title
            Text("Series Title")
            // description (almost null)
            Text("Description")
            // urls
            Text("URLs")
            // startYear, endYear, rating, next, prev (if needed)
        }
    }
    
    var comicsSection: some View {
        StandardSectionView(comics, title: "Comics", destination: Text("All Comics")) { comic in
            CardView2(title: comic.title, description: comic.description_)
                .frame(width: 200)
        }
    }
    
    var storiesSection: some View {
        StandardSectionView(stories, title: "Stories", destination: Text("All Stories")) { story in
            CardView2(title: story.title, description: story.description_)
                .frame(width: 200)
        }
    }
    
    var eventsSection: some View {
        StandardSectionView(events, title: "Events", destination: Text("All Events")) { event in
            CardView2(title: event.title, description: event.description_)
                .frame(width: 200)
        }
    }
    
    var charactersSection: some View {
        StandardSectionView(characters, title: "Characters", destination: Text("All Characters")) { character in
            CardView2(title: character.name, description: character.description_)
                .frame(width: 200)
        }
    }
    
    var creatorsSection: some View {
        StandardSectionView(creators, title: "Creators", destination: Text("All Creators")) { creator in
            CardView7(name: creator.fullName)
        }
    }
}

//struct SeriesDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeriesDetailsView()
//    }
//}
