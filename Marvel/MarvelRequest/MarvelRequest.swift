//
//  MarvelRequest.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation
import Combine

class MarvelRequest<Fetched> where Fetched: Codable, Fetched: Hashable {
    
    // MARK: - Fetched results
    
    private (set) var results = CurrentValueSubject<Set<Fetched>, Never>([]) // Consider using PassThrough?
    
    var total = 0 // The total number of resources available given the current filter set
    
    // MARK: - Shared Request Parameter(s)
    
    var limit = 10 // range = (1, 100]
    var offset = 0
    
    // MARK: - Subclasser override(s)
    
    var query: String { "" }
    func decode(_ json: Data) -> Set<Fetched> { [] }
    
    // MARK: - Private Data
    
    private var authorizedURL: URL? { URL(string: "https://gateway.marvel.com/v1/public/\(query)&\(Credential.info)") }
    private var fetchCancellable: AnyCancellable?
    
    // MARK: - Fetching
    
    func fetch() { // Consider to return the data task publisher
        if let url = authorizedURL {
            print("Fetching \(url)")
            fetchCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { [weak self] data, _ in self?.decode(data) ?? [] }
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .sink { [weak self] results in
                    if results.isEmpty {
                        print("returned empty set")
                        return
                    }
                    self?.handleResults(results)
                }
        } else {
            print("url does not valid/exist")
        }
    }
    
    func stopFetching() {
        fetchCancellable?.cancel()
    }
    
    // trial version, just emits the recently results from URLSession
    // may publishes the latest accumulate
    private func handleResults(_ newResults: Set<Fetched>) {
        results.value = newResults
        print("successful fetching")
    }
}

// MARK: - Extension(s)

extension String {
    mutating func addMarvelArgument(_ name: String, _ value: Int? = nil, `default` defaultValue: Int = 0) {
        if value != nil, value != defaultValue {
            addMarvelArgument(name, "\(value!)")
        }
    }
    
    // Add argument with date argument?
    
    mutating func addMarvelArgument(_ name: String, _ value: String? = nil) {
        if value != nil {
            self += (hasSuffix("?") ? "" : "&") + name + "=" + value!
        }
    }
}
