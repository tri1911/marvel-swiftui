//
//  EventDetailsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventDetailsView: View {
    let event: EventInfo
    
    var body: some View {
        ScrollView {
            VStack {
                mainInfo
                charactersSection
                comicsSection
                seriesSection
                storiesSection
                creatorsSection
            }
            
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var mainInfo: some View {
        VStack(spacing: 15) {
            // thumbnail
            WebImage(url: event.thumbnail.url)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(10.0)
            
            // title
            Text(event.title)
                .font(.title3)
                .fontWeight(.bold)
            
            // description
            VStack(alignment: .leading, spacing: 15) {
                Divider()
                Text("DETAILS").font(.headline)
                Text(event.description_)
            }
            
            // set of public websites
            HStack(spacing: 15) {
                let urls = event.urls
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
            
            VStack(alignment: .leading, spacing: 15) {
                Divider()
                Text("Information")
                    .font(.title3)
                    .fontWeight(.bold)
                
                // Start, End Date
                if let start = event.start, let end = event.end {
                    InformationCellView(name: "Start Date", content: start.formattedDate)
                    Divider()
                    InformationCellView(name: "End Date", content: end.formattedDate)
                    Divider()
                }
                
                // Next, Previous Event
                if let next = event.next {
                    Text(next.name)
                    Text(next.resourceURI)
                    Divider()
                }
                
                if let previous = event.previous {
                    Text(previous.name)
                    Text(previous.resourceURI)
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
    
    var charactersSection: some View {
        MarvelSectionView(CharacterFilter(eventId: event.id), title: "Characters", itemWidth: 200)
    }
    var comicsSection: some View {
        MarvelSectionView(ComicFilter(eventId: event.id), title: "Comics", itemWidth: 200)
    }
    
    var seriesSection: some View {
        MarvelSectionView(SeriesFilter(eventId: event.id), title: "Series", rowCount: 2)
    }
    
    var storiesSection: some View {
        MarvelSectionView(StoryFilter(eventId: event.id), title: "Stories", showsSeeAll: false, itemHeight: 300)
    }
    
    var creatorsSection: some View {
        MarvelSectionView(CreatorFilter(eventId: event.id), title: "Creators", showsSeeAll: false)
    }
}
