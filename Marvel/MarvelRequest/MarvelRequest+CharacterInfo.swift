//
//  MarvelRequest+CharacterInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation

struct CharacterInfo: Codable, Hashable, Identifiable {
    let id: Int // The unique ID of the character resource
    let name: String // The name of the character
    let description: String // A short bio or description of the character
    let modified: String // The date the resource was most recently modified
    let urls: [MarvelURL] // A set of public web site URLs for the resource
    let thumbnail: MarvelImage // The representative image for this character
    
    // MARK: - Syntactic Sugar
    
    var description_: String { description.isEmpty ? "Default Description for Character" : description }
    
    var modified_: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func == (lhs: CharacterInfo, rhs: CharacterInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct MarvelURL: Codable, Hashable {
    let type: String // A text identifier for the URL
    let url: String // A full URL (including scheme, domain, and path)
    
    var url_: URL? { URL(string: "https\(url.dropFirst(4))") }
}

struct MarvelImage: Codable {
    let path: String // The directory path of to the image
    let `extension`: String // The file extension for the image
    
    var url: URL? { URL(string: "https\(path.dropFirst(4)).\(`extension`)") }
}

struct CharacterFilter: Hashable {
    var name: String?
    var nameStartsWith: String?
    var modifiedSince: String?
    var comicId: Int?
    var seriesId: Int?
    var eventId: Int?
    var storyId: Int?
    var orderBy: String?
}

// TODO: share code with other InfoRequest

final class CharacterInfoRequest: MarvelRequest<CharacterInfo>, Codable, InfoRequest {
    
    static var requests = [CharacterFilter:CharacterInfoRequest]()
    
    static func create(_ filter: CharacterFilter, limit: Int?) -> CharacterInfoRequest {
        if let request = requests[filter] {
            return request
        } else {
            let request = CharacterInfoRequest(filter, limit: limit)
            request.fetch(useCache: false)
            requests[filter] = request
            return request
        }
    }
    
    // MARK: - Request Parameter(s)
    
    private(set) var filter: CharacterFilter?
    
    // MARK: - Initialization
    
    private init(_ filter: CharacterFilter, limit: Int?) {
        print("Creating the new Character Request...")
        super.init()
        self.filter = filter
        if limit != nil { self.limit = limit! }
    }
    
    // MARK: - Overrides
    
    override var cacheKey: String? { "\(type(of: self)).\(query)" }
    
    override var query: String {
        var request = "characters?"
        request.addMarvelArgument("name", filter?.name)
        request.addMarvelArgument("nameStartsWith", filter?.nameStartsWith)
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
    
    override func decode(_ json: Data) -> Array<CharacterInfo> {
        let result = (try? JSONDecoder().decode(CharacterInfoRequest.self, from: json))?.marvelResultData
        return result?.characters ?? []
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: CharacterDataContainer?
    
    private enum CodingKeys: String, CodingKey {
        case marvelResultData = "data"
    }
    
    struct CharacterDataContainer: Codable {
        let characters: [CharacterInfo]
        
        private enum CodingKeys: String, CodingKey {
            case characters = "results"
        }
    }
}
