//
//  MarvelStore.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-15.
//

import SwiftUI
import Combine

class MarvelStore: ObservableObject {
    @Published private(set) var characters = [CharacterFilter:Array<CharacterInfo>]()
    @Published private(set) var comics = [ComicFilter:Array<ComicInfo>]()
    
    private var cancellables = [AnyCancellable]()
    
    func fetch(_ filter: CharacterFilter, limit: Int? = nil) {
        let (request, new) = CharacterRequest.create(filter, limit: limit)
        if new {
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Characters")
                let oldValue = self?.characters[filter] ?? []
                self?.characters[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: false)
        }
    }
    
//    if (characters[filterSet]?.count ?? 0) < request.total {
    //            if limit != nil { request.limit = limit! }
    //            if let currentCount = characters[filterSet]?.count {
    //                request.offset = currentCount // Update offset
    //            }
    //            request.stopFetching()
    //            request.fetch()
    //        }
    
    func fetch(_ filter: ComicFilter, limit: Int? = nil) {
        let request = ComicRequest.create(filter, limit: limit)
        request.results.sink { [weak self] results in
            print("Returned \(results.count) Comics")
            let oldValue = self?.comics[filter] ?? []
            self?.comics[filter] = oldValue + results
        }.store(in: &cancellables)
        request.fetch(useCache: false)
    }
}
