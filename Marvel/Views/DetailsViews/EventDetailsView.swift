//
//  EventDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct EventDetailsView: View {
    @EnvironmentObject var store: MarvelStore
    
    let event: EventInfo
    
    // MARK: - Filters
    
    let creatorFilter: CreatorFilter
    let characterFilter: CharacterFilter
    let seriesFilter: SeriesFilter
    let comicFilter: ComicFilter
    let storyFilter: StoryFilter
    
    var creators: [CreatorInfo]? { store.creators[creatorFilter] }
    var characters: [CharacterInfo]? { store.characters[characterFilter] }
    var series: [SeriesInfo]? { store.series[seriesFilter] }
    var comics: [ComicInfo]? { store.comics[comicFilter] }
    var stories: [StoryInfo]? { store.stories[storyFilter] }
    
    init(_ event: EventInfo) {
        self.event = event
        self.creatorFilter = CreatorFilter(eventId: event.id)
        self.characterFilter = CharacterFilter(eventId: event.id)
        self.seriesFilter = SeriesFilter(eventId: event.id)
        self.comicFilter = ComicFilter(eventId: event.id)
        self.storyFilter = StoryFilter(eventId: event.id)
    }
    
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
        .onAppear {
            store.fetch(creatorFilter)
            store.fetch(characterFilter)
            store.fetch(seriesFilter)
            store.fetch(comicFilter)
            store.fetch(storyFilter)
        }
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
        StandardSectionView(characters, title: "Characters", destination: Text("All Characters")) { character in
            CardView2(title: character.name, description: character.description_)
                .frame(width: 200)
        }
    }
    
    var seriesSection: some View {
        StandardSectionView(series, title: "Series", destination: Text("All Series")) { series in
            CardView2(title: series.title, description: series.description_)
                .frame(width: 200)
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
    
    var creatorsSection: some View {
        StandardSectionView(creators, title: "Creators", destination: Text("All Creators")) { creator in
            CardView7(name: creator.fullName)
        }
    }
}

//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
