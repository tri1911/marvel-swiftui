//
//  HomeView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    // Overview
                    StandardSectionView(Array(0..<5), id: \.self) { _ in
                        CardView5()
                    }
                    
                    // Categories
                    VStack {
                        Divider().padding(.horizontal)
                        StandardHeaderView(title: "Categories").padding(.horizontal)
                        StandardSectionView(Category.allCases.map { $0.rawValue.capitalized }, id: \.self) { category in
                            CategoryCardView(content: category)
                        }
                    }
                    
                    // New Characters
                    MarvelSectionView<CharacterInfoRequest>(CharacterFilter(orderBy: "-modified"), title: "Characters", seeAllDestination: AnyView(Text("All Characters"))) { character in
                        AnyView(
                            CardView1(type: "Character", title: character.name, description: character.description, modified: character.modified_)
                        )
                    }
                    
                    //  Comics
                    MarvelSectionView<ComicInfoRequest>(ComicFilter(orderBy: "-modified"), title: "Newest Comics", seeAllDestination: AnyView(Text("All Comics"))) { comic in
                        AnyView(
                            CardView2(title: comic.title, description: comic.description_)
                                .frame(width: 165)
                        )
                    }
                    
                    // Events
                    MarvelSectionView<EventInfoRequest>(EventFilter(orderBy: "-modified"), title: "Incoming Events", rowCount: 3, seeAllDestination: AnyView(Text("All Events"))) { event in
                        AnyView(
                            CardView3(title: event.title, description: event.description)
                        )
                    }
                    
                    // Series
                    MarvelSectionView<SeriesInfoRequest>(SeriesFilter(orderBy: "-modified"), title: "New Release Series", rowCount: 2, seeAllDestination: AnyView(Text("All Series"))) { series in
                        AnyView(
                            CardView4(modified: series.modified, title: series.title, startYear: series.startYear, rating: series.rating )
                        )
                    }
                    
                    // Stories
                    MarvelSectionView<StoryInfoRequest>(StoryFilter(orderBy: "-modified"), title: "Newest Stories", seeAllDestination: AnyView(Text("All Stories"))) { story in
                        AnyView(
                            CardView6(title: story.title)
                        )
                    }

                    // Creators
                    MarvelSectionView<CreatorInfoRequest>(CreatorFilter(orderBy: "-modified"), title: "Popular Creators", seeAllDestination: AnyView(Text("All Creators"))) { creator in
                        AnyView(
                            CardView7(name: creator.fullName)
                        )
                    }
                }
            }
            .navigationTitle("Marvel")
        }
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
