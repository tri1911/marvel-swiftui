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
        MarvelSectionView<CharacterInfoRequest>(CharacterFilter(eventId: event.id), title: "Characters") { character in
            AnyView(
                CardView2(title: character.name, description: character.description_)
                .frame(width: 200)
            )
        }
    }
    
    var seriesSection: some View {
        MarvelSectionView<SeriesInfoRequest>(SeriesFilter(eventId: event.id), title: "Series") { series in
            AnyView(
                CardView2(title: series.title, description: series.description_)
                .frame(width: 200)
            )
        }
    }
    
    var comicsSection: some View {
        MarvelSectionView<ComicInfoRequest>(ComicFilter(eventId: event.id), title: "Comics") { comic in
            AnyView(
                CardView2(title: comic.title, description: comic.description_)
                .frame(width: 200)
            )
        }
    }
    
    var storiesSection: some View {
        MarvelSectionView<StoryInfoRequest>(StoryFilter(eventId: event.id), title: "Stories") { story in
            AnyView(
                CardView2(title: story.title, description: story.description_)
                .frame(width: 200)
            )
        }
    }
    
    var creatorsSection: some View {
        MarvelSectionView<CreatorInfoRequest>(CreatorFilter(eventId: event.id), title: "Creators") { creator in
            AnyView(
                CardView7(name: creator.fullName)
            )
        }
    }
}

//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
