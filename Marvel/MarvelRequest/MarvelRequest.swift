//
//  MarvelRequest.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import Foundation
import SwiftUI
import Combine

protocol InfoRequest: ObservableObject {
    associatedtype Filter: MarvelFilter
    associatedtype Info: Identifiable, Hashable
    
    var results: [Info]? { get }
    init(_ filter: Filter, limit: Int?, offset: Int?)
    func fetch(useCache: Bool)
    
    static var requests: [Filter:Self] { get set }
}

extension InfoRequest {
    // A shared function that creates and saves a request class based on a specified filter.
    // If the request does not exist, we create a new request and save it into `requests` for the next reference.
    // Otherwise, it just returns the saved request (in `requests` dictionary)
    static func create(_ filter: Filter, limit: Int? = nil, offset: Int? = nil, saveRequest: Bool = true) -> Self {
        print("Look up for the request...")
        if let request = requests[filter] {
            return request
        } else {
            let request = Self(filter, limit: limit, offset: offset)
            request.fetch(useCache: false)
            if saveRequest { requests[filter] = request }
            return request
        }
    }
}

protocol MarvelFilter: Hashable {
    associatedtype Request: InfoRequest where Self == Request.Filter
    associatedtype CardView: MarvelCardView where CardView.Info == Request.Info
}

protocol MarvelCardView: View {
    associatedtype Info
    init(_ info: Info)
}

struct MarvelDataWrapper<Info>: Codable where Info: Codable {
    let data: MarvelDataContainer
    
    struct MarvelDataContainer: Codable {
        let total: Int
        let results: [Info]
    }
}

class MarvelRequest<Filter, Info>: ObservableObject where Info: Codable {
    @Published private(set) var results: [Info]?
    @Published var offset = 0
    
    var filter: Filter?
    var limit = 20
    private(set) var total = 0 // The total number of resources available given the current filter set
    
    init(_ filter: Filter, limit: Int? = nil, offset: Int? = nil) {
        print("Created a new request.")
        self.filter = filter
        if limit != nil { self.limit = limit! }
        if offset != nil { self.offset = offset! }
    }
    
    // MARK: - Subclasser override
    
    var query: String { "" }
    
    // MARK: - Private Data
    
    private var authorizedURL: URL? { URL(string: "https://gateway.marvel.com/v1/public/\(query)&\(Credential.info)") }
    private var fetchCancellable: AnyCancellable?
    
    // MARK: - Fetching
    
    func decode(_ json: Data, caching: Bool = false) -> [Info] {
        if caching { cache(json) }
        let data = (try? JSONDecoder().decode(MarvelDataWrapper<Info>.self, from: json))?.data
        // Update the total value
        if let total = data?.total { self.total = total }
        return data?.results ?? []
    }
    
    func fetch(useCache: Bool = true) {
        if !useCache || !fetchFromCache() {
            if let url = authorizedURL {
                print("Fetching \(url).")
                fetchCancellable = URLSession.shared.dataTaskPublisher(for: url)
                    .map { [weak self] data, _ in self?.decode(data, caching: useCache) ?? [] }
                    .replaceError(with: [])
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] results in
                        let oldValue = self?.results ?? []
                        self?.results = oldValue + results
                        if results.isEmpty {
                            print("Returned empty set")
                        } else {
                            print("\(String(describing: self)): Successful fetching \(results.count) items (\(self?.total ?? 0) in total)")
                        }
                    }
            } else {
                print("invalid url!")
            }
        }
    }
    
    func stopFetching() { fetchCancellable?.cancel() }
    
    // MARK: - Caching to UserDefaults (For Testing purpose)
    
    private var cacheKey: String? { "\(type(of: self)).\(query)" }
    private var cachedData: Data? { cacheKey != nil ? UserDefaults.standard.data(forKey: cacheKey!) : nil }
    
    private func cache(_ json: Data) {
        if let key = cacheKey {
            print("Caching data for key \(key)")
            UserDefaults.standard.set(json, forKey: key)
        }
    }
    
    private func fetchFromCache() -> Bool {
        if let key = cacheKey, let data = cachedData {
            print("Fetching cached data (key: \(key))")
            let newResults = self.decode(data)
            let oldValue = results ?? []
            results = oldValue + newResults
            print("Successfully fetching from cache")
            return true
        }
        return false
    }    
}
