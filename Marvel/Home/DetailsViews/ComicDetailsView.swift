//
//  ComicDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicDetailsView: View {
    static let thumbnailSize: (width: CGFloat, height: CGFloat) = (200, 200)
    
    let comic: ComicInfo
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                overview
                charactersSection
                creatorsSection
                fullDescription
                detailsInformation
                seriesSection
                storiesSection
                eventsSection
                Spacer()
            }
            .padding()
        }
        .navigationTitle(comic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Section(s)
    
    var overview: some View {
        VStack(alignment: .center, spacing: 15) {
            // Promotional Images
            TabView {
                ForEach(comic.images, id: \.self) { image in
                    WebImage(url: image.url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFit()
                        .cornerRadius(10.0)
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
                let urls = comic.urls
                ForEach(urls, id: \.self) { url in
                    let title = url.type.capitalized
                    if let validURL = url.url_ {
                        NavigationLink(destination: WebView(url: validURL).navigationTitle(title)) {
                            Text(title)
                        }
                        
                        if let index = urls.firstIndex { $0 == url }, index != urls.count - 1 {
                            Image(systemName: "circle.fill").font(.system(size: 3))
                        }
                    }
                }
            }
            .lineLimit(1)
        }
        .padding(.horizontal)
    }

    var charactersSection: some View {
        MarvelSectionView(CharacterFilter(comicId: comic.id), title: "Characters", itemWidth: 165)
    }
    
    var seriesSection: some View {
        MarvelSectionView(SeriesFilter(comicId: comic.id), title: "Series", rowCount: 2)
    }
    
    var eventsSection: some View {
        MarvelSectionView(EventFilter(comicId: comic.id), title: "Events", rowCount: 3)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(comicId: comic.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
    
    var creatorsSection: some View {
        MarvelSectionView(CreatorFilter(comicId: comic.id), title: "Creators", showsSeeAll: false)
    }
    
    var fullDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
            Text("ABOUT").font(.headline)
            Text(comic.description_)
        }
        .padding(.horizontal)
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
        .padding(.horizontal)
    }
}
