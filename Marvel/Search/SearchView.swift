//
//  SearchView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-22.
//

import SwiftUI
import Combine
import CoreData

class SearchStore: ObservableObject {
    @Published var searchText = ""
    @Published var selectedScope = 0
    
    // Enum represents the scope search.
    enum ScopeSearch: Int, CaseIterable {
        case all = 0
        case favourites
        // Syntactic Sugar
        var title: String { "\(self)".capitalized }
        static var titles: [String] { Self.allCases.map { $0.title } }
    }
}

struct SearchView: View {
    @StateObject var store = SearchStore()
    
    var body: some View {
        UINavigationControllerRepresentation(
            selectedScope: $store.selectedScope,
            searchText: $store.searchText,
            scopeSearch: SearchStore.ScopeSearch.titles
        ) {
            SearchResultsView(store: store)
        }
        .ignoresSafeArea()
    }
}

struct SearchResultsView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    // Did not use @ObservedObject to prevent the body recreated
    // every time the searchText property got changed
    var store: SearchStore
    
    @State var query = ""
    @State var selectedScope = 0
    
    var scopeSearch: SearchStore.ScopeSearch? { SearchStore.ScopeSearch(rawValue: selectedScope) }
    
    var body: some View {
        ScrollView {
            if query.isEmpty {
                DefaultSearchResultsView()
            } else {
                VStack(spacing: 40) {
                    switch scopeSearch {
                    case .all:
                        MarvelSectionView(CharacterFilter(nameStartsWith: query), saveRequest: false, title: "Characters", rowCount: 2, itemWidth: 165)
                        MarvelSectionView(ComicFilter(titleStartsWith: query), saveRequest: false, title: "Comics", itemWidth: 250)
                        MarvelSectionView(EventFilter(nameStartsWith: query), saveRequest: false, title: "Events", rowCount: 3)
                        MarvelSectionView(SeriesFilter(titleStartsWith: query), saveRequest: false, title: "Series", showsSeeAll: false, verticalDirection: true)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .onReceive(store.$selectedScope) { selected in
            self.selectedScope = selected
        }
        .onReceive(
            store.$searchText
                .removeDuplicates()
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        ) { searchText in
            if searchText != query {
                print("Published searchText: \(searchText)")
                query = searchText.replacingOccurrences(of: " ", with: "%20")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
