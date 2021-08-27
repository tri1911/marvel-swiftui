//
//  EventsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-27.
//

import SwiftUI

struct EventsView: View {
    var body: some View {
        ScrollView {
            MarvelSectionView(EventFilter(orderBy: "-startDate"), showsSeeAll: false, verticalDirection: true)
        }
        .navigationTitle("Events")
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
