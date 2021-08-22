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
        MarvelSectionView(ComicFilter(characterId: character.id), title: "Comics", itemWidth: CharacterDetailsView.thumbnailSize.width)
    }
    
    var seriesSection: some View {
        MarvelSectionView(SeriesFilter(characterId: character.id), title: "Series", rowCount: 2)
    }
    
    var eventsSection: some View {
        MarvelSectionView(EventFilter(characterId: character.id), title: "Events", rowCount: 3)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(characterId: character.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
}
