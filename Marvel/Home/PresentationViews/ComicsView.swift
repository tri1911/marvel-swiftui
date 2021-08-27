//
//  ComicsView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

struct ComicsView: View {
    @State private var formatTypeSelection: ComicFilter.FormatType = .comic
    
    var format: ComicFilter.Format? { formatTypeSelection == .collection ? nil : .comic }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .thisWeek, orderBy: "-issueNumber"), title: "New Releases", itemWidth: 200)
                    MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .lastWeek, orderBy: "-issueNumber"), title: "Last Week Releases", itemWidth: 200)
                    MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .nextWeek, orderBy: "-issueNumber"), title: "Incoming \(formatTypeSelection.rawValue.capitalized)", itemWidth: 200)
                    MarvelSectionView(ComicFilter(format: format, formatType: formatTypeSelection, dateDescriptor: .thisMonth, orderBy: "-onsaleDate"), title: "This Month Sale", itemWidth: 200)
                }
                // .animation(.default)
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
