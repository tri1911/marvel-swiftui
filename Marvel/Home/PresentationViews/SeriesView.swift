//
//  SeriesView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-27.
//

import SwiftUI

// TODO: Request in body will be recreated frequently
struct SeriesView: View {
    var body: some View {
        ScrollView {
            MarvelSectionView(SeriesFilter(contains: .comic, orderBy: "-startYear"), title: "Contains Comics", rowCount: 2)
            MarvelSectionView(SeriesFilter(contains: .graphicNovel, orderBy: "-startYear"), title: "Contains Graphic Novels", rowCount: 2)
            MarvelSectionView(SeriesFilter(contains: .hardcover, orderBy: "-startYear"), title: "Contains HardCovers", rowCount: 2)
            MarvelSectionView(SeriesFilter(contains: .magazine, orderBy: "-startYear"), title: "Contains Magazines", rowCount: 2)
        }
        .navigationTitle("Series")
    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView()
    }
}
