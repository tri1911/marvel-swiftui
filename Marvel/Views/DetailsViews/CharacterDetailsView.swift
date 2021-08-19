//
//  CharacterDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct CharacterDetailsView: View {
    static let thumbnailSize: (width: CGFloat, height: CGFloat) = (200, 200)
    
    @EnvironmentObject var store: MarvelStore
    
    let character: CharacterInfo
    
    // MARK: - Filters
    
    let comicFilter: ComicFilter
    let seriesFilter: SeriesFilter
    let eventFilter: EventFilter
    let storyFilter: StoryFilter
    
    init(_ character: CharacterInfo) {
        self.character = character
        comicFilter = ComicFilter(characterId: character.id)
        seriesFilter = SeriesFilter(characterId: character.id)
        eventFilter = EventFilter(characterId: character.id)
        storyFilter = StoryFilter(characterId: character.id)
    }
    
    var comics: [ComicInfo]? { store.comics[comicFilter] }
    var series: [SeriesInfo]? { store.series[seriesFilter] }
    var events: [EventInfo]? { store.events[eventFilter] }
    var stories: [StoryInfo]? { store.stories[storyFilter] }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                mainInfo
                comicsSection
                seriesSection
                eventsSection
                storiesSection
                Spacer()
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.fetch(comicFilter)
            store.fetch(seriesFilter)
            store.fetch(eventFilter)
            store.fetch(storyFilter)
        }
    }
    
    var mainInfo: some View {
        VStack(alignment: .center, spacing: 15) {
            Image.soobinThumbnail(width: CharacterDetailsView.thumbnailSize.width,
                                  height: CharacterDetailsView.thumbnailSize.height)
            Text(character.name)
                .font(.title3)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 15) {
                Divider()
                Text("ABOUT").font(.headline)
                Text(character.description_)
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 15) {
                Text("Detail")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("Wiki")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("ComicLink")
                Spacer()
            }
        }
        .padding()
    }
    
    var comicsSection: some View {
        StandardSectionView(comics, title: "Comics", destination: Text("All Comics")) { comic in
            CardView2(title: comic.title, description: comic.description_)
                .frame(width: CharacterDetailsView.thumbnailSize.width)
        }
    }
    
    var seriesSection: some View {
        StandardSectionView(series, title: "Series", destination: Text("All Series")) { series in
            CardView2(title: series.title, description: series.description_)
                .frame(width: CharacterDetailsView.thumbnailSize.width)
        }
    }
    
    var eventsSection: some View {
        StandardSectionView(events, title: "Events", destination: Text("All Events")) { event in
            CardView2(title: event.title, description: event.description_)
                .frame(width: CharacterDetailsView.thumbnailSize.width)
        }
    }
    
    var storiesSection: some View {
        StandardSectionView(stories, title: "Stories", destination: Text("All Stories")) { story in
            CardView2(title: story.title, description: story.description_)
                .frame(width: CharacterDetailsView.thumbnailSize.width)
        }
    }
}

//struct CharacterDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterDetailsView()
//    }
//}
