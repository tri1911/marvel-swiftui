//
//  SeriesView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-27.
//

import SwiftUI

// TODO: Request in body will be recreated frequently
struct SeriesView: View {
    init() {
        print("SeriesView created...")
    }
    
    var body: some View {
        ScrollView {
            // TODO: Sections based on comic format contains
            MarvelSectionView(SeriesFilter(orderBy: "-startYear"), showsSeeAll: false, verticalDirection: true)
        }
        .navigationTitle("Series")
    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView()
    }
}
