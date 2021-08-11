//
//  CharactersStore.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI
import Combine

struct CharacterFilterSet: Hashable {
    var comicId: Int?
    var name: String?
    var nameStartsWith: String?
}

class CharacterStore: ObservableObject {
    
    // MARK: - Requests Store
    
    private var requests = [CharacterFilterSet:CharacterRequest]()
    private var cancellables = [AnyCancellable]()
    
    // MARK: - Characters Store
    
    @Published private(set) var characters = [CharacterFilterSet:Set<CharacterInfo>]()
    
    func fetch(_ filterSet: CharacterFilterSet, limit: Int? = nil, offset: Int? = nil) {
        // Already exist, reuse it
        if  let request = requests[filterSet] {
            // If request the same url, continueing fetching the rest of data
            if (characters[filterSet]?.count ?? 0) < request.total {
                if limit != nil { request.limit = limit! }
                if offset != nil { request.offset = offset! }
                request.stopFetching()
                request.fetch()
            } else { // If already fetch all data, then don't do anything
                print("Don't Fetch")
            }
        } else {
            // Create a new one
            let request = CharacterRequest(search: filterSet, limit: limit, offset: offset)
            requests[filterSet] = request // Save the request for later reference
            request.fetch()
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Characters")
                let oldValue = self?.characters[filterSet]
                self?.characters[filterSet] = results.union(oldValue ?? [])
                print("self?.characters[search].count=\(self?.characters[filterSet]?.count ?? -1)")
            }.store(in: &cancellables)
        }
    }
}
