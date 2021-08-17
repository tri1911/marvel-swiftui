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
    let characterFilter: CharacterFilter
    
    init(_ comic: ComicInfo) {
        self.comic = comic
        characterFilter = CharacterFilter(comicId: comic.id)
    }
    
    var characters: [CharacterInfo]? { store.characters[characterFilter] }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // Overview Information
                overview
                // Promotional Images
                promotionalImages
                // Related Characters
                relatedCharacters
                // Other Related Categories
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
        .onAppear { store.fetch(characterFilter) }
    }
    
    // MARK: - Section(s)
    
    var overview: some View {
        VStack(alignment: .center, spacing: 15) {
            // Thumbnail
            Image.soobinThumbnail(width: ComicDetailsView.thumbnailSize.width,
                                  height: ComicDetailsView.thumbnailSize.height)
            // Title
            Text(comic.title)
                .font(.title3)
                .fontWeight(.bold)
            // Brief Description
            Text(comic.description_)
                //.fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var promotionalImages: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<5, id: \.self) { _ in // Replace with comic.images
                    Image.soobinThumbnail(width: 200, height: 100)
                }
            }
        }
    }
    
    var relatedCharacters: some View {
        StandardSectionView(characters, title: "Featured Characters", destination: Text("All Featured Characters")) { character in
            CardView2(title: character.name, description: character.description_)
                .frame(width: ComicDetailsView.thumbnailSize.width)
        }
    }
    
    var fullDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
            Text("ABOUT").font(.headline)
            Text(comic.description_)
                //.fixedSize(horizontal: false, vertical: true)
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
