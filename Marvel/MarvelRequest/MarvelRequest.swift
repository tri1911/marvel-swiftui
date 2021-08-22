//
//  MarvelRequest.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation
import Combine

struct MarvelDataWrapper<Info>: Codable where Info: Codable {
    let data: MarvelDataContainer
    
    struct MarvelDataContainer: Codable {
        let results: [Info]
    }
}

class MarvelRequest<Filter, Info> where Info: Codable {
    private(set) var results = CurrentValueSubject<Array<Info>, Never>([])
    private(set) var filter: Filter?
    private(set) var limit = 10
    private(set) var offset = 0
    
    init(_ filter: Filter, limit: Int?) {
        self.filter = filter
        if limit != nil { self.limit = limit! }
    }
    
    // MARK: - Subclasser override
    
    var query: String { "" }
    
    // MARK: - Private Data
    
    private var authorizedURL: URL? { URL(string: "https://gateway.marvel.com/v1/public/\(query)&\(Credential.info)") }
    private var fetchCancellable: AnyCancellable?
    
    // MARK: - Fetching
    
    func decode(_ json: Data) -> [Info] {
        let data = (try? JSONDecoder().decode(MarvelDataWrapper<Info>.self, from: json))?.data
        return data?.results ?? []
    }
    
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
    
    // MARK: - Caching (For Testing purpose)
    
    private var cacheKey: String? { "\(type(of: self)).\(query)" }
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
