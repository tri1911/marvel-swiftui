//
//  SearchStore.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-22.
//

import SwiftUI
import Combine

class SearchStore: ObservableObject {
    @Published var searchText = ""
    @Published var selectedScope = 0 {
        didSet {
            if !searchText.isEmpty {
                search(searchText)
            }
        }
    }
    
    var scopeSearch: ScopeSearch? { ScopeSearch(rawValue: selectedScope) }
    
    // Enum represents the scope search.
    enum ScopeSearch: Int, CaseIterable {
        case characters = 0
        case comics
        // Syntactic Sugar
        var title: String { "\(self)".capitalized }
        static var titles: [String] { Self.allCases.map { $0.title } }
    }
    
    // The stored property to keep the subscription to the change
    // of user input live along with the class lifecycle.
    private var searchCancellable: AnyCancellable?
    
    init() {
        // Subscribes to the change of search text.
        searchCancellable = $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] query in
                if !query.isEmpty {
                    self?.search(query)
                }
            }
    }
    
    // MARK: - Searching
    
    // Marvel requests
    private var characterRequest: CharacterInfoRequest!
    private var comicRequest: ComicInfoRequest!
    private var marvelResultCancellable: AnyCancellable?
    
    // Marvel Results Stores
    @Published var characters: [CharacterInfo]?
    @Published var comics: [ComicInfo]?
    
    private func search(_ query: String) {
        switch scopeSearch {
        case .characters:
            // Cancel the most recent fetching (if it does exist)
            marvelResultCancellable = nil
            characterRequest?.stopFetching()
            characterRequest = nil
            // Create a request for characters (with the nameStartWith parameter = query)
            characterRequest = CharacterInfoRequest(CharacterFilter(nameStartsWith: query))
            // Start fetching
            characterRequest?.fetch(useCache: false)
            // Subscribe to the subject (named as results) in the request class
            // Assign the returned results to characters store
            marvelResultCancellable = characterRequest.results.sink { [weak self] results in
                print("Return \(results.count) characters")
                self?.characters = results
            }
            characters = nil
        case .comics:
            // Cancel the most recent fetching (if exist)
            marvelResultCancellable = nil
            comicRequest?.stopFetching()
            comicRequest = nil
            // Create a request for comics (with the titleStartsWith parameter = query)
            comicRequest = ComicInfoRequest(ComicFilter(titleStartsWith: query))
            // Start fetching
            comicRequest?.fetch(useCache: false)
            // Subscribe to the subject (named as results) in the request class
            // Assign the returned results to comics store
            marvelResultCancellable = comicRequest.results.sink { [weak self] results in
                self?.comics = results
                print("Return \(results.count) comics")
            }
            comics = nil
        default:
            break
        }
    }
}
