//
//  FeaturedComicsSectionView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeaturedComicsSectionView: View {
    @StateObject var request: ComicInfoRequest
    
    var comics: [ComicInfo]? { request.results }
    
    init(_ filter: ComicFilter) {
        _request = .init(wrappedValue: ComicInfoRequest.create(filter, limit: 10))
    }
    
    var body: some View {
        StandardSectionView(comics) { comic in
            FeaturedComicCardView(comic: comic)
        }
    }
}

struct FeaturedComicCardView: View {
    let comic: ComicInfo
    
    var screenWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        NavigationLink(destination: ComicDetailsView(comic: comic)) {
            VStack(alignment: .leading) {
                Divider()
                Text("New Release".uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text(comic.title)
                    .font(.title2)
                Text("Published by Marvel.")
                    .font(.title3)
                    .foregroundColor(.gray)
                WebImage(url: comic.thumbnail.url)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: screenWidth * 0.9, height: 170)
                    .cornerRadius(10.0)
                // Image.soobinThumbnail(width: screenWidth * 0.9, height: 150)
            }
            .frame(maxWidth: screenWidth * 0.9)
        }
    }
}
