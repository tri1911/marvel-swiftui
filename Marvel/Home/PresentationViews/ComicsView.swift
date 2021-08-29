//
//  ComicsView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct ComicsView: View {
    @State private var formatTypeSelection: ComicFilter.FormatType = .comic
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    // TODO: MarvelSectionView didn't recreated when formatTypeSelection get changed
                    // MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .thisWeek, orderBy: "-issueNumber"), title: "New Releases", itemWidth: 200)
                    // MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .lastWeek, orderBy: "-issueNumber"), title: "Last Week Releases", itemWidth: 200)
                    // MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .nextWeek, orderBy: "-issueNumber"), title: "Incoming \(formatTypeSelection.rawValue.capitalized)", itemWidth: 200)
                    // MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .thisMonth, orderBy: "-onsaleDate"), title: "This Month Sale", itemWidth: 200)
                    switch formatTypeSelection {
                    case .comic:
                        MarvelSectionView(ComicFilter(format: .comic, formatType: .comic, orderBy: "focDate"), title: "Recently Published", itemWidth: 200) // 40740 in total
                        MarvelSectionView(ComicFilter(format: .comic, formatType: .comic, hasDigitalIssue: true, orderBy: "focDate"), title: "Digital Issues", itemWidth: 200) // 28182 in total
                        MarvelSectionView(ComicFilter(format: .comic, formatType: .comic, dateDescriptor: .thisMonth, orderBy: "onsaleDate"), title: "On Sale This Month", itemWidth: 200) // 190 in Total
                        MarvelSectionView(ComicFilter(format: .comic, formatType: .comic, dateDescriptor: .lastWeek, orderBy: "-issueNumber"), title: "Last Week Releases", itemWidth: 200) // 33 in Total
                    case.collection:
                        MarvelSectionView(ComicFilter(formatType: .collection, orderBy: "focDate"), title: "Recently Published", itemWidth: 200) // 7303 in total
                        MarvelSectionView(ComicFilter(formatType: .collection, hasDigitalIssue: true, orderBy: "focDate"), title: "Digital Issues", itemWidth: 200) // 12 in total
                        MarvelSectionView(ComicFilter(formatType: .collection, dateDescriptor: .thisMonth, orderBy: "onsaleDate"), title: "On Sale This Month", itemWidth: 200) // 24 in Total
                        MarvelSectionView(ComicFilter(formatType: .collection, dateDescriptor: .lastWeek, orderBy: "-issueNumber"), title: "Last Week Releases", itemWidth: 200) // 5 in Total
                    }
                }
            }
            .navigationTitle("Comics")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Every time picker selection changed, body recreated...
                    Picker("Format Type", selection: $formatTypeSelection) {
                        ForEach(ComicFilter.FormatType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
            }
        }
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}
