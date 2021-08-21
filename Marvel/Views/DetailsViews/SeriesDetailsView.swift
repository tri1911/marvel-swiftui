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
        MarvelSectionView<ComicInfoRequest>(ComicFilter(seriesId: series.id), title: "Comics") { comic in
            AnyView(
                CardView2(title: comic.title, description: comic.description_)
                    .frame(width: 200)
            )
        }
    }
    
    var storiesSection: some View {
        MarvelSectionView<StoryInfoRequest>(StoryFilter(seriesId: series.id), title: "Stories") { story in
            AnyView(
                CardView2(title: story.title, description: story.description_)
                    .frame(width: 200)
            )
        }
    }
    
    var eventsSection: some View {
        MarvelSectionView<EventInfoRequest>(EventFilter(seriesId: series.id), title: "Events") { event in
            AnyView(
                CardView2(title: event.title, description: event.description_)
                    .frame(width: 200)
            )
        }
    }
    
    var charactersSection: some View {
        MarvelSectionView<CharacterInfoRequest>(CharacterFilter(seriesId: series.id), title: "Characters") { character in
            AnyView(
                CardView2(title: character.name, description: character.description_)
                    .frame(width: 200)
            )
        }
    }
    
    var creatorsSection: some View {
        MarvelSectionView<CreatorInfoRequest>(CreatorFilter(seriesId: series.id), title: "Creators") { creator in
            AnyView(
                CardView7(name: creator.fullName)
            )
        }
    }
}

//struct SeriesDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeriesDetailsView()
//    }
//}
