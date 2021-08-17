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
    let comicFilter: ComicFilter
    
    init(_ character: CharacterInfo) {
        self.character = character
        comicFilter = ComicFilter(characterId: character.id)
    }
    
    var comics: [ComicInfo]? { store.comics[comicFilter] }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                mainInfo
                relatedComics
                Spacer()
            }
        }
        .navigationTitle("Character Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.fetch(comicFilter) }
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
    
    var relatedComics: some View {
        StandardSectionView(comics, title: "Related Comics", destination: Text("All Related Comics")) { comic in
            CardView2(title: comic.title, description: comic.description_)
                .frame(width: CharacterDetailsView.thumbnailSize.width)
        }
    }
}

//struct CharacterDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterDetailsView()
//    }
//}
