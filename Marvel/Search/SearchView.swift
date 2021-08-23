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
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var searchStore: SearchStore
    @Binding var selectedScope: Int
    @Binding var searchText: String
    
    var scopeSearch: SearchStore.ScopeSearch? { SearchStore.ScopeSearch(rawValue: selectedScope) }
    
    var body: some View {
        if searchStore.searchText.isEmpty {
            DefaultSearchResultsView()
        } else {
            switch scopeSearch {
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
            ProgressView().scaleEffect(1.5)
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
            ProgressView().scaleEffect(1.5)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
