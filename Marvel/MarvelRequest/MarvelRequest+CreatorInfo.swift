//
//  MarvelRequest+CreatorInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-15.
//

import Foundation

struct CreatorInfo: Codable, Identifiable {
    let id: Int // The unique ID of the creator resource
    let firstName: String // The first name of the creator
    let middleName: String // The middle name of the creator
    let lastName: String // The last name of the creator
    let suffix: String // The suffix or honorific for the creator
    let fullName: String // The full name of the creator (a space-separated concatenation of the above four fields)
    let modified: String // The date the resource was most recently modified
    let urls: [MarvelURL] // A set of public web site URLs for the resource
    let thumbnail: MarvelImage // The representative image for this creator
    
    // MARK: - Syntactic Sugar
    
    var modified_: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
}

struct CreatorFilter: Hashable {
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var suffix: String?
    var nameStartsWith: String?
    var firstNameStartsWith: String?
    var middleNameStartsWith: String?
    var lastNameStartsWith: String?
    var modifiedSince: String?
    var comicId: Int?
    var seriesId: Int?
    var eventId: Int?
    var storyId: Int?
    var orderBy: String?
}

// TODO: share code with other InfoRequest

class CreatorInfoRequest: MarvelRequest<CreatorInfo>, Codable {
    
    static var requests = [CreatorFilter:CreatorInfoRequest]()
    
    static func create(_ filter: CreatorFilter, limit: Int?) -> (CreatorInfoRequest, Bool) {
        if let request = requests[filter] {
            return (request, false)
        } else {
            let request = CreatorInfoRequest(filter, limit: limit)
            requests[filter] = request
            return (request, true)
        }
    }
    
    // MARK: - Request Parameter(s)
    
    private(set) var filter: CreatorFilter?
    
    // MARK: - Initialization
    
    private init(_ filter: CreatorFilter, limit: Int?) {
        print("Creating the new Creator Request...")
        super.init()
        self.filter = filter
        if limit != nil { self.limit = limit! }
    }
    
    // MARK: - Overrides
    
    override var cacheKey: String? { "\(type(of: self)).\(query)" }
    
    override var query: String {
        var request = "creators?"
        request.addMarvelArgument("firstName", filter?.firstName)
        request.addMarvelArgument("middleName", filter?.middleName)
        request.addMarvelArgument("lastName", filter?.lastName)
        request.addMarvelArgument("suffix", filter?.suffix)
        request.addMarvelArgument("nameStartsWith", filter?.nameStartsWith)
        request.addMarvelArgument("firstNameStartsWith", filter?.firstNameStartsWith)
        request.addMarvelArgument("middleNameStartsWith", filter?.middleNameStartsWith)
        request.addMarvelArgument("lastNameStartsWith", filter?.lastNameStartsWith)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("comics", filter?.comicId)
        request.addMarvelArgument("series", filter?.seriesId)
        request.addMarvelArgument("events", filter?.eventId)
        request.addMarvelArgument("stories", filter?.storyId)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> Array<CreatorInfo> {
        let result = (try? JSONDecoder().decode(CreatorInfoRequest.self, from: json))?.marvelResultData
        return result?.creators ?? []
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: CreatorDataContainer?
    
    private enum CodingKeys: String, CodingKey {
        case marvelResultData = "data"
    }
    
    struct CreatorDataContainer: Codable {
        let creators: [CreatorInfo]
        
        private enum CodingKeys: String, CodingKey {
            case creators = "results"
        }
    }
}
