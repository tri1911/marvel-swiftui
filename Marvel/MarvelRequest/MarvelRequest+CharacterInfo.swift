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
    
    var modifiedDate: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }

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

struct CharacterFilter: Hashable {
    var name: String?
    var nameStartsWith: String?
    var comicId: Int?
    var modifiedSince: String?
    var orderBy: String?
}

class CharacterRequest: MarvelRequest<CharacterInfo>, Codable {
    
    static var requests = [CharacterFilter:CharacterRequest]()
    
    static func create(_ filter: CharacterFilter, limit: Int?) -> (CharacterRequest, Bool) {
        let request = requests[filter]
        if request == nil {
            let request = CharacterRequest(filter, limit: limit)
            requests[filter] = request
            return (request, true)
        } else {
            return (request!, false)
        }
    }
    
    // MARK: - Request Parameter(s)
    
    private(set) var filter: CharacterFilter?
    
    // MARK: - Initilization
    
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
        request.addMarvelArgument("comics", filter?.comicId)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> Array<CharacterInfo> {
        let result = (try? JSONDecoder().decode(CharacterRequest.self, from: json))?.marvelResultData
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



