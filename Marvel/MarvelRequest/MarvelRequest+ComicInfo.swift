//
//  MarvelRequest+ComicInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation

struct ComicInfo: Codable, Hashable, Identifiable {
    let id: Int // The unique ID of the comic resource
    let title: String // The canonical title of the comic
    let description: String? // The preferred description of the comic
    let modified: String // The date the resource was most recently modified
    let isbn: String // The ISBN for the comic (generally only populated for collection formats)
    let format: String // The publication format of the comic e.g. comic, hardcover, trade paperback
    let pageCount: Int // The number of story pages in the comic
    let urls: [ComicURL] // A set of public web site URLs for the resource
    let thumbnail: ComicImage // The representative image for this comic
    let images: [ComicImage] // A list of promotional images associated with this comic
    
    var modifiedDate: Date { ISO8601DateFormatter().date(from: modified)! }
    
    struct ComicURL: Codable {
        let type: String // A text identifier for the URL
        let urlString: String // A full URL (including scheme, domain, and path)
        
        var url: URL? { URL(string: "https\(urlString.dropFirst(4))") }
        
        private enum CodingKeys: String, CodingKey {
            case type
            case urlString = "url"
        }
    }
    
    struct ComicImage: Codable, Hashable {
        let path: String // (string, optional): The directory path of to the image.,
        let ext: String // (string, optional): The file extension for the image.
        
        var url: URL? { URL(string: "https\(path.dropFirst(4)).\(ext)") }
        
        private enum CodingKeys: String, CodingKey {
            case path
            case ext = "extension"
        }
    }
    
    static func == (lhs: ComicInfo, rhs: ComicInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

class ComicRequest: MarvelRequest<ComicInfo>, Codable {
    
    // MARK: - Request Parameter(s)
    
    private(set) var characterId: Int?
    private(set) var format: String?
    private(set) var title: String?
    private(set) var titleStartsWith: String?
    private(set) var startYear: String?
    private(set) var isbn: String?
    
    // MARK: - Initialization
    
    init(characterId: Int? = nil, format: String? = nil, title: String? = nil, titleStartsWith: String? = nil, startYear: String? = nil, isbn: String? = nil, limit: Int? = nil, offset: Int? = nil) {
        super.init()
        self.characterId = characterId
        self.format = format
        self.title = title
        self.titleStartsWith = titleStartsWith
        self.startYear = startYear
        self.isbn = isbn
        if limit != nil { self.limit = limit! }
        if offset != nil { self.offset = offset! }
    }
    
    // MARK: - Overrides
    
    override var query: String {
        var request = (characterId != nil ? "characters/\(characterId!)/" : "") + "comics?"
        request.addMarvelArgument("format", format)
//        request.addMarvelArgument("title", title)
//        request.addMarvelArgument("titleStartsWith", titleStartsWith)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> Set<ComicInfo> {
        let result = (try? JSONDecoder().decode(ComicRequest.self, from: json))?.marvelResultData
        return Set(result?.comics ?? [])
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: ComicDataContainer? // The results returned by the call
    
    private enum CodingKeys: String, CodingKey {
        case marvelResultData = "data"
    }
    
    struct ComicDataContainer: Codable {
        let comics: [ComicInfo]
        
        private enum CodingKeys: String, CodingKey {
            case comics = "results"
        }
    }
    
}
