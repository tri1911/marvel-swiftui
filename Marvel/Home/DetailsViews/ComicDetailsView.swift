//
//  ComicDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-16.
//

import SwiftUI

struct ComicDetailsView: View {
    static let thumbnailSize: (width: CGFloat, height: CGFloat) = (200, 200)
    
    let comic: ComicInfo
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                overview
                charactersSection
                seriesSection
                eventsSection
                storiesSection
                creatorsSection
                fullDescription
                detailsInformation
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Comic Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Section(s)
    
    var overview: some View {
        VStack(alignment: .center, spacing: 15) {
            // Promotional Images
            TabView {
                ForEach(0..<5, id: \.self) { _ in // Replace with comic.images
                    Image.soobinThumbnail()
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
                Text("Detail")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("Wiki")
                Image(systemName: "circle.fill").font(.system(size: 3))
                Text("ComicLink")
            }
        }
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
