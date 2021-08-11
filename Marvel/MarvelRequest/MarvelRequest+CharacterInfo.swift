//
//  MarvelRequest+CharacterInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation
import Combine

struct CharacterInfo: Codable, Hashable, Identifiable {
    let id: Int // The unique ID of the character resource
    let name: String // The name of the character
    let description: String // A short bio or description of the character
    let modified: String // The date the resource was most recently modified
    let urls: [CharacterURL] // A set of public web site URLs for the resource
    let thumbnail: CharacterImage // The representative image for this character
    
    var modifiedDate: Date? { ISO8601DateFormatter().date(from: modified) }

    struct CharacterURL: Codable, Hashable {
        let type: String // A text identifier for the URL
        let urlString: String // A full URL (including scheme, domain, and path)
        
        var url: URL? { URL(string: "https\(urlString.dropFirst(4))") }
    
        private enum CodingKeys: String, CodingKey {
            case type
            case urlString = "url"
        }
    }
    
    struct CharacterImage: Codable {
        let path: String // The directory path of to the image
        let ext: String // The file extension for the image
        
        var url: URL? { URL(string: "https\(path.dropFirst(4)).\(ext)") }
        
        private enum CodingKeys: String, CodingKey {
            case path
            case ext = "extension"
        }
    }
    
    static func == (lhs: CharacterInfo, rhs: CharacterInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

class CharacterRequest: MarvelRequest<CharacterInfo>, Codable {
    
    // MARK: - Request Parameter(s)
        
    private(set) var comicId: Int?
    private(set) var name: String?
    private(set) var nameStartsWith: String?
    
    // MARK: - Initilization
    
    init(comicId: Int? = nil, name: String? = nil, nameStartsWith: String? = nil, limit: Int? = nil, offset: Int? = nil) {
        super.init()
        self.comicId = comicId
        self.name = name
        self.nameStartsWith = nameStartsWith
        if limit != nil { self.limit = limit! }
        if offset != nil { self.offset = offset! }
    }
    
    convenience init(search: CharacterFilterSet, limit: Int? = nil, offset: Int? = nil) {
        print("Created new Request")
        self.init(comicId: search.comicId, name:search.name, nameStartsWith: search.nameStartsWith, limit: limit, offset: offset)
    }
    
    // MARK: - Overrides
    
    override var query: String {
        var request = (comicId != nil ? "comics/\(comicId!)/" : "") + "characters?"
        request.addMarvelArgument("name", name)
        request.addMarvelArgument("nameStartsWith", nameStartsWith)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> Set<CharacterInfo> {
        if let result = (try? JSONDecoder().decode(CharacterRequest.self, from: json))?.marvelResultData {
            self.offset += result.count // Update the next offset
            self.total = result.total // TODO: avoid updating the same thing multiple times
            return Set(result.characters)
        }
        return []
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: CharacterDataContainer? // The results returned by the call
    
    private enum CodingKeys: String, CodingKey {
        case marvelResultData = "data"
    }
    
    struct CharacterDataContainer: Codable {
//        let offset: Int // The requested offset (number of skipped results) of the call
        let total: Int // The total number of resources available given the current filter set
        let count: Int // The total number of results returned by this call
        let characters: [CharacterInfo] // The list of characters returned by the call
        
        private enum CodingKeys: String, CodingKey {
//            case offset
            case total
            case count
            case characters = "results"
        }
    }
}



