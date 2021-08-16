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
    
    var modifiedDate: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    
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

struct ComicFilter: Hashable {
    var format: String?
    var formatType: String?
    var dateDescriptor: String?
    var title: String?
    var titleStartsWith: String?
    var startYear: Int?
    var isbn: String?
    var characterId: Int?
    var modifiedSince: String?
    var orderBy: String?
}

class ComicRequest: MarvelRequest<ComicInfo>, Codable {
    
    static var requests = [ComicFilter:ComicRequest]()
    
    static func create(_ filter: ComicFilter, limit: Int?) -> ComicRequest {
        let request = requests[filter]
        if request == nil {
            let request = ComicRequest(filter, limit: limit)
            requests[filter] = request
            return request
        } else {
            return request!
        }
    }
    
    // MARK: - Request Parameter(s)
    
    private(set) var filter: ComicFilter?

    // MARK: - Initialization
    
    init(_ filter: ComicFilter, limit: Int? = nil) {
        print("Creating the new Comic Request...")
        super.init()
        self.filter = filter
        if limit != nil { self.limit = limit! }
    }
    
    // MARK: - Overrides
    
    override var cacheKey: String? { "\(type(of: self)).\(query)" }
    
    override var query: String {
        var request = "comics?"
        request.addMarvelArgument("format", filter?.format)
        request.addMarvelArgument("formatType", filter?.formatType)
        request.addMarvelArgument("dateDescriptor", filter?.dateDescriptor)
        request.addMarvelArgument("title", filter?.title)
        request.addMarvelArgument("titleStartsWith", filter?.titleStartsWith)
        request.addMarvelArgument("startYear", filter?.startYear)
        request.addMarvelArgument("isbn", filter?.isbn)
        request.addMarvelArgument("characterId", filter?.characterId)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("orderBy", filter?.orderBy)

        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
    
    override func decode(_ json: Data) -> [ComicInfo] {
        let result = (try? JSONDecoder().decode(ComicRequest.self, from: json))?.marvelResultData
        return result?.comics ?? []
    }
    
    // MARK: - Decoding Data Structure
    
    private var marvelResultData: ComicDataContainer?
    
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
