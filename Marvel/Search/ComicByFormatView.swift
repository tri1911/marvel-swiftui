//
//  ComicByFormatView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-27.
//

import SwiftUI

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
