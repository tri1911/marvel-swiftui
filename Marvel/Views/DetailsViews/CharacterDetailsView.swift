//
//  CharacterDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct CharacterDetailsView: View {
    static let thumbnailSize: (width: CGFloat, height: CGFloat) = (200, 200)
    
    let character: CharacterInfo
    
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
        MarvelSectionView<ComicInfoRequest>(ComicFilter(characterId: character.id), title: "Comics") {
            comic in
            AnyView (
                CardView2(title: comic.title, description: comic.description_)
                    .frame(width: CharacterDetailsView.thumbnailSize.width)
            )
        }
    }
    
    var seriesSection: some View {
        MarvelSectionView<SeriesInfoRequest>(SeriesFilter(characterId: character.id), title: "Series") {
            series in
            AnyView (
                CardView2(title: series.title, description: series.description_)
                    .frame(width: CharacterDetailsView.thumbnailSize.width)
            )
        }
    }
    
    var eventsSection: some View {
        MarvelSectionView<EventInfoRequest>(EventFilter(characterId: character.id), title: "Events") {
            event in
            AnyView (
                CardView2(title: event.title, description: event.description_)
                    .frame(width: CharacterDetailsView.thumbnailSize.width)
            )
        }
    }
    
    var storiesSection: some View {
        MarvelSectionView<StoryInfoRequest>(StoryFilter(characterId: character.id), title: "Stories") {
            story in
            AnyView (CardView2(title: story.title, description: story.description_)
                    .frame(width: CharacterDetailsView.thumbnailSize.width)
            )
        }
    }
}

//struct CharacterDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterDetailsView()
//    }
//}
