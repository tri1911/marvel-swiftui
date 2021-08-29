//
//  SeriesDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import SDWebImageSwiftUI

struct SeriesDetailsView: View {
    let series: SeriesInfo
    
    var body: some View {
        ScrollView {
            VStack {
                mainInfo
                comicsSection
                creatorsSection
                storiesSection
                charactersSection
                eventsSection
            }
        }
        .navigationTitle(series.title)
    }
    
    var mainInfo: some View {
        VStack(spacing: 15) {
            // thumbnail
            WebImage(url: series.thumbnail.url)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(10.0)
            // title
            Text(series.title)
                .font(.title3)
                .fontWeight(.bold)
            
            // set of public websites
            HStack(spacing: 15) {
                let urls = series.urls
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
            
            // startYear, endYear, rating, next, previous (if needed)
            VStack(alignment: .leading, spacing: 15) {
                Divider()
                Text("Information")
                    .font(.title3)
                    .fontWeight(.bold)
                
                // Start, End Date
                InformationCellView(name: "Start Year", content: String(series.startYear))
                Divider()
                InformationCellView(name: "End Year", content: String(series.endYear))
                Divider()
                
                // Next, Previous Series
                if let next = series.next {
                    Text(next.name)
                    Text(next.resourceURI)
                    Divider()
                }
                
                if let previous = series.previous {
                    Text(previous.name)
                    Text(previous.resourceURI)
                    Divider()
                }
            }
            
        }
        .padding(.horizontal)
    }
    
    var comicsSection: some View {
        MarvelSectionView(ComicFilter(seriesId: series.id), title: "Comics", itemWidth: 200)
    }
    
    var charactersSection: some View {
        MarvelSectionView(CharacterFilter(seriesId: series.id), title: "Characters", itemWidth: 165)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(seriesId: series.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
    
    var eventsSection: some View {
        MarvelSectionView(EventFilter(seriesId: series.id), title: "Events", rowCount: 3)
    }
    
    var creatorsSection: some View {
        MarvelSectionView(CreatorFilter(seriesId: series.id), title: "Creators", showsSeeAll: false)
    }
}
