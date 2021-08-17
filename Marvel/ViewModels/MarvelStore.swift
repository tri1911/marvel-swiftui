//
//  MarvelStore.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-15.
//

import SwiftUI
import Combine

class MarvelStore: ObservableObject {

    // MARK: - Store(s)
    
    @Published private(set) var characters = [CharacterFilter:Array<CharacterInfo>]()
    @Published private(set) var comics = [ComicFilter:Array<ComicInfo>]()
    @Published private(set) var creators = [CreatorFilter:Array<CreatorInfo>]()
    @Published private(set) var events = [EventFilter:Array<EventInfo>]()
    @Published private(set) var series = [SeriesFilter:Array<SeriesInfo>]()
    @Published private(set) var stories = [StoryFilter:Array<StoryInfo>]()
    
    // MARK: - Fetching
    
    private var cancellables = [AnyCancellable]()
    
    func fetch(_ filter: CharacterFilter, limit: Int? = nil) {
        let (request, new) = CharacterInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Characters")
                let oldValue = self?.characters[filter] ?? []
                self?.characters[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
        //    if (characters[filterSet]?.count ?? 0) < request.total {
        //            if limit != nil { request.limit = limit! }
        //            if let currentCount = characters[filterSet]?.count {
        //                request.offset = currentCount // Update offset
        //            }
        //            request.stopFetching()
        //            request.fetch()
        //        }
    }
    
    
    func fetch(_ filter: ComicFilter, limit: Int? = nil) {
        let (request, new) = ComicInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Comics")
                let oldValue = self?.comics[filter] ?? []
                self?.comics[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
    }
    
    func fetch(_ filter: CreatorFilter, limit: Int? = nil) {
        let (request, new) = CreatorInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Creators")
                let oldValue = self?.creators[filter] ?? []
                self?.creators[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
    }
    
    func fetch(_ filter: EventFilter, limit: Int? = nil) {
        let (request, new) = EventInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Events")
                let oldValue = self?.events[filter] ?? []
                self?.events[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
    }
    
    func fetch(_ filter: SeriesFilter, limit: Int? = nil) {
        let (request, new) = SeriesInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Series")
                let oldValue = self?.series[filter] ?? []
                self?.series[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
    }
    
    func fetch(_ filter: StoryFilter, limit: Int? = nil) {
        let (request, new) = StoryInfoRequest.create(filter, limit: limit)
        if new {
            print("Start subscribing to the new request...")
            request.results.sink { [weak self] results in
                print("Returned \(results.count) Stories")
                let oldValue = self?.stories[filter] ?? []
                self?.stories[filter] = oldValue + results
            }.store(in: &cancellables)
            request.fetch(useCache: true)
        }
    }
}
