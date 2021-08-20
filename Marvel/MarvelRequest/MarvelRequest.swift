//
//  MarvelRequest.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation
import Combine

class MarvelRequest<Info> where Info: Codable {
    
    // MARK: - Fetched results
    
    private (set) var results = CurrentValueSubject<Array<Info>, Never>([])
    
    // MARK: - Shared Request Parameter(s)
    
    var limit = 10
    var offset = 0
    
    // MARK: - Subclasser override(s)
    
    var query: String { "" }
    func decode(_ json: Data) -> Array<Info> { [] }
    
    // MARK: - Private Data
    
    private var authorizedURL: URL? { URL(string: "https://gateway.marvel.com/v1/public/\(query)&\(Credential.info)") }
    private var fetchCancellable: AnyCancellable?
    
    // MARK: - Fetching
    
    func fetch(useCache: Bool = true) {
        if !useCache || !fetchFromCache() {
            if let url = authorizedURL {
                print("Fetching \(url)")
                fetchCancellable = URLSession.shared.dataTaskPublisher(for: url)
                    .map { [weak self] data, _ in self?.decode(data) ?? [] }
                    .replaceError(with: [])
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] results in
                        self?.results.send(results) // Possibly return an empty result
                        if results.isEmpty {
                            print("returned empty set")
                        } else if useCache {
                            self?.cache(results)
                            print("successful fetching")
                        }
                    }
            } else {
                print("invalid url!")
            }
        }
    }
    
    func stopFetching() { fetchCancellable?.cancel() }
    
    // MARK: - Caching
    
    var cacheKey: String? { "\(type(of: self)).\(query)" }
    private var cachedData: Data? { cacheKey != nil ? UserDefaults.standard.data(forKey: cacheKey!) : nil }
    
    private func cache(_ newResults: Array<Info>) {
        if let key = cacheKey, let data = try? JSONEncoder().encode(newResults) {
            print("caching data for key \(key)")
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func fetchFromCache() -> Bool {
        if let key = cacheKey, let data = cachedData {
            print("Fetching cached data (key: \(key))")
            if let decodedData = try? JSONDecoder().decode(Array<Info>.self, from: data) {
                results.send(decodedData)
                print("successfully fetching from cache")
                return true
            } else {
                print("Can't decode the cachedData")
            }
        }
        return false
    }
}

// MARK: - Extension(s)

extension String {
    mutating func addMarvelArgument(_ name: String, _ value: Int? = nil, `default` defaultValue: Int = 0) {
        if value != nil, value != defaultValue {
            addMarvelArgument(name, "\(value!)")
        }
    }
    
    mutating func addMarvelArgument(_ name: String, _ value: Date?) {
        if value != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            addMarvelArgument(name, dateFormatter.string(from: value!))
        }
    }
    
    mutating func addMarvelArgument(_ name: String, _ value: String? = nil) {
        if value != nil {
            self += (hasSuffix("?") ? "" : "&") + name + "=" + value!
        }
    }
}
