//
//  MarvelRequest+EventInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-16.
//

import Foundation

struct EventInfo: Codable, Identifiable, Hashable {
    let id: Int // The unique ID of the event resource
    let title: String // The title of the event
    let description: String // A description of the event
    let urls: [MarvelURL] // A set of public web site URLs for the event
    let modified: String // The date the resource was most recently modified
    let start: String? // The date of publication of the first issue in this event
    let end: String? // The date of publication of the last issue in this event
    let thumbnail: MarvelImage // The representative image for this event
    let next: EventSummary? // A summary representation of the event which follows this event
    let previous: EventSummary? // A summary representation of the event which preceded this event
    
    // MARK: - Syntactic Sugar
    
    var description_: String { description.isEmpty ? "Default Description for Event" : description }
    
    var modified_: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    
    struct EventSummary: Codable {
        let resourceURI: String // The path to the individual event resource
        let name: String // The name of the event
        
        var url: URL? { URL(string: "https\(resourceURI.dropFirst(4))") }
    }
    
    static func == (lhs: EventInfo, rhs: EventInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct EventFilter: Hashable {
    var name: String?
    var nameStartsWith: String?
    var modifiedSince: String?
    var creatorId: Int?
    var characterId: Int?
    var seriesId: Int?
    var comicId: Int?
    var storyId: Int?
    var orderBy: String?
}

// TODO: share code with other InfoRequest

class EventInfoRequest: MarvelRequest<EventInfo>, Codable {
    
    static var requests = [EventFilter:EventInfoRequest]()
    
    static func create(_ filter: EventFilter, limit: Int?) -> (EventInfoRequest, Bool) {
        if let request = requests[filter] {
            return (request, false)
        } else {
            let request = EventInfoRequest(filter, limit: limit)
            requests[filter] = request
            return (request, true)
        }
    }
    
    // MARK: - Request Parameter(s)
    
    private(set) var filter: EventFilter?
    
    // MARK: - Initialization
    
    private init(_ filter: EventFilter, limit: Int?) {
        print("Creating the new Character Request...")
        super.init()
        self.filter = filter
        if limit != nil { self.limit = limit! }
    }
    
    // MARK: - Overrides
    
    override var cacheKey: String? { "\(type(of: self)).\(query)" }
    
    override var query: String {
        var request = "events?"
        request.addMarvelArgument("name", filter?.name)
        request.addMarvelArgument("nameStartsWith", filter?.nameStartsWith)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("creators", filter?.creatorId)
        request.addMarvelArgument("characters", filter?.characterId)
        request.addMarvelArgument("series", filter?.seriesId)
        request.addMarvelArgument("comics", filter?.comicId)
        request.addMarvelArgument("stories", filter?.storyId)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> Array<EventInfo> {
        let result = (try? JSONDecoder().decode(EventInfoRequest.self, from: json))?.marvelResultData
        return result?.events ?? []
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: EventDataContainer?
    
    private enum CodingKeys: String, CodingKey {
        case marvelResultData = "data"
    }
    
    struct EventDataContainer: Codable {
        let events: [EventInfo]
        
        private enum CodingKeys: String, CodingKey {
            case events = "results"
        }
    }
}
