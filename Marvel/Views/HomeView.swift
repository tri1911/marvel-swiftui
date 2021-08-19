//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Store Object(s)
    
    @EnvironmentObject var store: MarvelStore
    
    // MARK: - Filter Set(s)
    
    private let characterFilter = CharacterFilter(orderBy: "-modified")
    private let comicFilter = ComicFilter(orderBy: "-modified")
    private let creatorFilter = CreatorFilter(orderBy: "-modified")
    private let eventFilter = EventFilter(orderBy: "-modified")
    private let seriesFilter = SeriesFilter(orderBy: "-modified")
    private let storyFilter = StoryFilter(orderBy: "-modified")
    
    // MARK: - Fetched Results
    
    private var characters: [CharacterInfo]? { store.characters[characterFilter] }
    private var comics: [ComicInfo]? { store.comics[comicFilter] }
    private var creators: [CreatorInfo]? { store.creators[creatorFilter] }
    private var events: [EventInfo]? { store.events[eventFilter] }
    private var series: [SeriesInfo]? { store.series[seriesFilter] }
    private var stories: [StoryInfo]? { store.stories[storyFilter] }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    // Overview
                    SectionDemoView1()
                    
                    // Categories
                    SectionDemoView2(Category.allCases.map { $0.rawValue.capitalized }, title: "Categories")
                    
                    // New Characters
                    StandardSectionView(characters, title: "Newest Characters", destination: SeeAllDemoView1(characters ?? [], titleKey: \.name, descriptionKey: \.description)) { character in
                        NavigationLink(destination: CharacterDetailsView(character)) {
                            CardView1(type: "Character", title: character.name, description: character.description, modified: character.modified_)
                        }
                    }
                    
                    //  Comics
                    StandardSectionView(comics, title: "Newest Comics", destination: SeeAllDemoView2(comics ?? [], titleKey: \.title, descriptionKey: \.description_)) { comic in
                        NavigationLink(destination: ComicDetailsView(comic)) {
                            CardView2(title: comic.title, description: comic.description_)
                                .frame(width: 165)
                        }
                    }
                    
                    // Events
                    StandardSectionView(divides(events, groupOf: 3), id: \.self, title: "Incoming Events", destination: Text("All Events")) { events in
//                        CardView3(items: events, titleKey: \.title, descriptionKey: \.description)
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(events) { event in
                                NavigationLink(destination: EventDetailsView(event)) {
                                    StandardCardView1(title: event.title, description: event.description)                                    
                                }
                                if let index = events.firstIndex { $0.id == event.id }, index != events.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    // Series
                    StandardSectionView(divides(series, groupOf: 2), id: \.self, title: "New Release Series", destination: Text("All Series")) { series in
//                        CardView4(items: series, titleKey: \.title, modifiedKey: \.modified, startYearKey: \.startYear, ratingKey: \.rating)
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(series) { item in
                                NavigationLink(destination: SeriesDetailsView(item)) {
                                    StandardCardView2(modified: item.modified, title: item.title, startYear: item.startYear, rating: item.rating )
                                }
                                if let index = series.firstIndex { $0.id == item.id }, index != series.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    // Stories
                    StandardSectionView(stories, title: "Newest Stories", showsSeeAll: false, destination: Text("All Stories")) { story in
                        CardView6(title: story.title)
                    }

                    // Creators
                    StandardSectionView(creators, title: "Popular Creators", destination: Text("All Creators")) { creator in
                        NavigationLink(destination: CreatorDetailsView(creator)) {
                            CardView7(name: creator.fullName)
                        }
                    }
                }
            }
            .navigationTitle("Marvel")
            .onAppear {
                store.fetch(characterFilter)
                store.fetch(comicFilter)
                store.fetch(creatorFilter)
                store.fetch(eventFilter)
                store.fetch(seriesFilter)
                store.fetch(storyFilter)
            }
        }
    }
    
    private func divides<Item>(_ items: [Item]?, groupOf count: Int) -> [[Item]]? {
        if items != nil {
            return Dictionary(grouping: items!.enumerated()) { $0.offset / count } // Divides elements into groups of three
                .sorted { $0.key < $1.key } // Sorted by keys
                .map { $0.value.map { $0.element } } // Extract groups of desired elements
        }
        return nil
    }
}

enum Category: String, CaseIterable {
    case characters, comics, events, series, stories, creators
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
    }
}
