//
//  MarvelRequest+StoryInfo.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import Foundation

struct StoryInfo: Codable, Identifiable, Hashable {
    let id: Int // The unique ID of the story resource
    let title: String // The story title
    let description: String? // A short description of the story
    let type: String // The story type e.g. interior story, cover, text story
    let modified: String // The date the resource was most recently modified
    let thumbnail: MarvelImage? // The representative image for this story
    let originalissue: ComicSummary? // A summary representation of the issue in which this story was originally published
    
    // MARK: - Syntactic Sugar
    
    var description_: String { description == nil ? "Default Description for Story" : description! }
    
    struct ComicSummary: Codable {
        let resourceURI: String //  The path to the individual series resource
        let name: String //  The canonical name of the series
        
        var url: URL? { URL(string: "https\(resourceURI.dropFirst(4))") }
    }
    
    static func == (lhs: StoryInfo, rhs: StoryInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct StoryFilter: MarvelFilter {
    typealias Request = StoryInfoRequest
    typealias CardView = StoryCardView
    var modifiedSince: String?
    var comicId: Int?
    var seriesId: Int?
    var eventId: Int?
    var creatorId: Int?
    var characterId: Int?
    var orderBy: String?
}

final class StoryInfoRequest: MarvelRequest<StoryFilter, StoryInfo>, InfoRequest {
    
    static var requests = [StoryFilter:StoryInfoRequest]()

    override var query: String {
        var request = "stories?"
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("comics", filter?.comicId)
        request.addMarvelArgument("series", filter?.seriesId)
        request.addMarvelArgument("events", filter?.eventId)
        request.addMarvelArgument("creators", filter?.creatorId)
        request.addMarvelArgument("characters", filter?.characterId)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
}
