//
//  DefaultSearchResultsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct DefaultSearchResultsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
                .padding(.horizontal)
            
            StandardHeaderView<AnyView>(title: "Browse Categories")
                .padding(.horizontal)
            
            StandardGridView(items: Array(ComicFilter.Format.allCases.dropFirst())) { format in
                NavigationLink(destination: ComicByFormatView(format: format)) {
                    ZStack(alignment: .bottomLeading) {
                        RadialGradient(gradient: Gradient(colors: [.purple, .blue]), center: .topLeading, startRadius: 5, endRadius: 500)
                        Text(format.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    .cornerRadius(10.0)
                    .aspectRatio(1.5, contentMode: .fit)
                }
            }
        }
    }
}

struct ComicByFormatView: View {
    let format: ComicFilter.Format
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                MarvelSectionView(ComicFilter(format: format, orderBy: "-focDate"), title: "New Releases", itemWidth: 200)
                MarvelSectionView(ComicFilter(format: format, startYear: 2020), title: "\(format.title) in 2020", itemWidth: 200)
                MarvelSectionView(ComicFilter(format: format, orderBy: "-modified"), title: "Recently Updated", itemWidth: 200)
                MarvelSectionView(ComicFilter(format: format, orderBy: "-onsaleDate"), title: "New On Sale", itemWidth: 200)
            }
        }
        .navigationTitle(format.title)
    }
}
