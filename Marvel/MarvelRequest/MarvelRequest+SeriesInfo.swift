//
//  MarvelRequest+SeriesInfo.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import Foundation

struct SeriesInfo: Codable, Identifiable, Hashable {
    let id: Int // The unique ID of the series resource
    let title: String // The canonical title of the series
    let description: String? // A description of the series
    let urls: [MarvelURL] // Array[Url], optional): A set of public web site URLs for the resource
    let startYear: Int // The first year of publication for the series
    let endYear: Int // The last year of publication for the series (conventionally, 2099 for ongoing series)
    let rating: String // The age-appropriateness rating for the series
    let modified: String // The date the resource was most recently modified
    let thumbnail: MarvelImage // The representative image for this series
    let next: SeriesSummary? // A summary representation of the series which follows this series
    let previous: SeriesSummary? // A summary representation of the series which preceded this series
    
    // MARK: - Syntactic Sugar
    
    var description_: String { description == nil ? "Default Description for Series" : description! }
    
    struct SeriesSummary: Codable {
        let resourceURI: String //  The path to the individual series resource
        let name: String //  The canonical name of the series
        
        var url: URL? { URL(string: "https\(resourceURI.dropFirst(4))") }
    }
    
    static func == (lhs: SeriesInfo, rhs: SeriesInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct SeriesFilter: MarvelFilter {
    typealias Request = SeriesInfoRequest
    typealias CardView = SeriesCardView
    var title: String?
    var titleStartsWith: String? // Searching parameter
    var startYear: Int?
    var modifiedSince: String?
    var comicId: Int?
    var storyId: Int?
    var eventId: Int?
    var creatorId: Int?
    var characterId: Int?
    var seriesType: SeriesType?
    var contains: ComicFilter.Format?
    var orderBy: String?
    
    enum SeriesType: String, CaseIterable {
        case collection, oneshot, limited, ongoing
    }
}

final class SeriesInfoRequest: MarvelRequest<SeriesFilter, SeriesInfo>, InfoRequest {
    
    static var requests = [SeriesFilter:SeriesInfoRequest]()

    override var query: String {
        var request = "series?"
        request.addMarvelArgument("title", filter?.title)
        request.addMarvelArgument("titleStartsWith", filter?.titleStartsWith)
        request.addMarvelArgument("startYear", filter?.startYear)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("comics", filter?.comicId)
        request.addMarvelArgument("stories", filter?.storyId)
        request.addMarvelArgument("events", filter?.eventId)
        request.addMarvelArgument("creators", filter?.creatorId)
        request.addMarvelArgument("characters", filter?.characterId)
        request.addMarvelArgument("seriesType", filter?.seriesType?.rawValue)
        request.addMarvelArgument("contains", filter?.contains?.rawValue)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
}

