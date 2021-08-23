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
        case all = 0
        case characters
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
    
    // TODO: Consider Dictionary containing stores, requests
    
    // Marvel requests
    private var characterRequest: CharacterInfoRequest!
    private var comicRequest: ComicInfoRequest!
    
    private var marvelResultCancellable: AnyCancellable?
    private var cancellables = [AnyCancellable]()
    
    // Marvel Results Stores
    @Published var characters: [CharacterInfo]?
    @Published var comics: [ComicInfo]?
    
    private func search(_ query: String) {
        switch scopeSearch {
        case .all:
            // Stop subscribing to all requests
            cancellables.removeAll()
            
            // Stop fetching
            characterRequest?.stopFetching()
            comicRequest?.stopFetching()
            characterRequest = nil
            comicRequest = nil
            
            // Create new requests based on the 'query' parameter
            characterRequest = CharacterInfoRequest(CharacterFilter(nameStartsWith: query))
            comicRequest = ComicInfoRequest(ComicFilter(titleStartsWith: query))
            
            // Start fetching
            characterRequest?.fetch(useCache: false)
            comicRequest?.fetch(useCache: false)
            
            // Subscribe to requests
            characterRequest.results
                .sink { [weak self] results in
                    print("Return \(results.count) Characters")
                    self?.characters = results
                }
                .store(in: &cancellables)
            
            comicRequest.results
                .sink { [weak self] results in
                    print("Return \(results.count) Comics")
                    self?.comics = results
                }
                .store(in: &cancellables)
            
            // Reset stores to nil
            characters = nil
            comics = nil
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
            }
            comics = nil
        default:
            break
        }
    }
}
