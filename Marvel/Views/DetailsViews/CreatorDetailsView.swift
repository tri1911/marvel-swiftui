//
//  CreatorDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-18.
//

import SwiftUI

struct CreatorDetailsView: View {    
    let creator: CreatorInfo
    
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
    }
    
    var comicsSection: some View {
        MarvelSectionView<ComicInfoRequest>(ComicFilter(creatorId: creator.id), title: "Comics") { comic in
            AnyView(
                CardView2(title: comic.title, description: comic.description_)
                .frame(width: 200)
            )
        }
    }
    
    var seriesSection: some View {
        MarvelSectionView<SeriesInfoRequest>(SeriesFilter(creatorId: creator.id), title: "Series") { series in
            AnyView(
                CardView2(title: series.title, description: series.description_)
                .frame(width: 200)
            )
        }
    }
    
    var eventsSection: some View {
        MarvelSectionView<EventInfoRequest>(EventFilter(creatorId: creator.id), title: "Events") { event in
            AnyView(
                CardView2(title: event.title, description: event.description_)
                .frame(width: 200)
            )
        }
    }
    
    var storiesSection: some View {
        MarvelSectionView<StoryInfoRequest>(StoryFilter(creatorId: creator.id), title: "Stories") { story in
            AnyView(
                CardView2(title: story.title, description: story.description_)
                .frame(width: 200)
            )
        }
    }
}

//struct CreatorDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorDetailsView()
//    }
//}
