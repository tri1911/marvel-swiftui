//
//  ComicDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-16.
//

import SwiftUI

struct ComicDetailsView: View {
    static let thumbnailSize: (width: CGFloat, height: CGFloat) = (200, 200)
    
    @EnvironmentObject var store: MarvelStore
    
    let comic: ComicInfo
    
    // MARK: - Filters
    
    let creatorFilter: CreatorFilter
    let characterFilter: CharacterFilter
    let seriesFilter: SeriesFilter
    let eventFilter: EventFilter
    let storyFilter: StoryFilter
    
    init(_ comic: ComicInfo) {
        self.comic = comic
        creatorFilter = CreatorFilter(comicId: comic.id)
        characterFilter = CharacterFilter(comicId: comic.id)
        seriesFilter = SeriesFilter(comicId: comic.id)
        eventFilter = EventFilter(comicId: comic.id)
        storyFilter = StoryFilter(comicId: comic.id)
    }
    
    var creators: [CreatorInfo]? { store.creators[creatorFilter] }
    var characters: [CharacterInfo]? { store.characters[characterFilter] }
    var series: [SeriesInfo]? { store.series[seriesFilter] }
    var events: [EventInfo]? { store.events[eventFilter] }
    var stories: [StoryInfo]? { store.stories[storyFilter] }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // Overview Information
                overview
                // Creators
                creatorsSection
                // Characters
                charactersSection
                // Series
                seriesSection
                // Events
                eventsSection
                // Stories
                storiesSection
                // Full Description
                fullDescription
                // More detail information
                detailsInformation
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Comic Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.fetch(creatorFilter)
            store.fetch(characterFilter)
            store.fetch(seriesFilter)
            store.fetch(eventFilter)
            store.fetch(storyFilter)
        }
    }
    
    // MARK: - Section(s)
    
    var overview: some View {
        VStack(alignment: .center, spacing: 15) {
            // Promotional Images
            TabView {
                ForEach(0..<5, id: \.self) { _ in // Replace with comic.images
                    Image.soobinThumbnail()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 250)
            .cornerRadius(10.0)
            // Title
            Text(comic.title)
                .font(.title3)
                .fontWeight(.bold)
            // Brief Description
            Text(comic.description_)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            // Set of public websites
            HStack(spacing: 15) {
                Text("Detail")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("Wiki")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("ComicLink")
            }
        }
    }
    
    var creatorsSection: some View {
        StandardSectionView(creators, title: "Featured Creators", destination: Text("All Creators")) { creator in
            CardView7(name: creator.fullName)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var charactersSection: some View {
        StandardSectionView(characters, title: "Featured Characters", destination: Text("All Characters")) { character in
            CardView2(title: character.name, description: character.description_)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var seriesSection: some View {
        StandardSectionView(series, title: "Featured series", destination: Text("All series")) { series in
            CardView2(title: series.title, description: series.description_)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var eventsSection: some View {
        StandardSectionView(events, title: "Featured events", destination: Text("All events")) { event in
            CardView2(title: event.title, description: event.description_)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var storiesSection: some View {
        StandardSectionView(stories, title: "Featured stories", destination: Text("All stories")) { story in
            CardView2(title: story.title, description: story.description_)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var fullDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
            Text("ABOUT").font(.headline)
            Text(comic.description_)
        }
    }
    
    var detailsInformation: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
            Text("Information")
                .font(.title3)
                .fontWeight(.bold)
            
            InformationCellView(name: "ISBN", content: comic.isbn)
            Divider()
            InformationCellView(name: "Format", content: comic.format)
            Divider()
            InformationCellView(name: "Pages", content: String(comic.pageCount))
        }
    }
    
    // MARK: - Reusable View(s)
    
    struct InformationCellView: View {
        let name: String
        let content: String
        
        var body: some View {
            HStack {
                Text(name).foregroundColor(.gray)
                Spacer()
                Text(content.isEmpty ? "Info Content" : content)
            }
        }
    }
}

//struct ComicDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComicDetailsView()
//    }
//}
