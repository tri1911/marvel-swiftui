//
//  SearchView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchStore = SearchStore()
    
    var body: some View {
        UINavigationControllerRepresentation(selectedScope: $searchStore.selectedScope, searchText: $searchStore.searchText, scopeSearch: SearchStore.ScopeSearch.titles) {
            SearchResultsView(selectedScope: $searchStore.selectedScope, searchText: $searchStore.searchText).environmentObject(searchStore)
        }
        .ignoresSafeArea()
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var searchStore: SearchStore
    @Binding var selectedScope: Int
    @Binding var searchText: String
    
    var scopeSearch: SearchStore.ScopeSearch? { SearchStore.ScopeSearch(rawValue: selectedScope) }
    
    var body: some View {
        if searchText.isEmpty {
            DefaultSearchResultsView()
        } else {
            switch scopeSearch {
            case .all:
                searchAllResults
            case .characters:
                characterSearchResults
            case .comics:
                comicSearchResults
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    var searchAllResults: some View {
        if let characters = searchStore.characters, let comics = searchStore.comics {
            if characters.isEmpty && comics.isEmpty {
                Text("Empty Results")
            } else {
                List {
                    Section(header: Text("Characters")) {
                        ForEach(characters) { character in
                            Text(character.name)
                        }
                    }
                    
                    Section(header: Text("Comics")) {
                        ForEach(comics) { comic in
                            Text(comic.title)
                        }
                    }
                }
            }
        } else {
            LoadingView()
        }
    }
    
    @ViewBuilder
    var characterSearchResults: some View {
        if let characters = searchStore.characters {
            if characters.isEmpty {
                Text("Empty")
            } else {
                List {
                    ForEach(characters) { character in
                        Text(character.name)
                    }
                }  
            }
        } else {
            LoadingView()
        }
    }
    
    @ViewBuilder
    var comicSearchResults: some View {
        if let comics = searchStore.comics {
            if comics.isEmpty {
                Text("Empty")
            } else {
                List {
                    ForEach(comics) { comic in
                        Text(comic.title)
                    }
                }
            }
        } else {
            LoadingView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
