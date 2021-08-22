//
//  MarvelRequest+ComicInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation

struct ComicInfo: Codable, Identifiable, Hashable {
    let id: Int // The unique ID of the comic resource
    let title: String // The canonical title of the comic
    let description: String? // The preferred description of the comic
    let modified: String // The date the resource was most recently modified
    let isbn: String // The ISBN for the comic (generally only populated for collection formats)
    let format: String // The publication format of the comic e.g. comic, hardcover, trade paperback
    let pageCount: Int // The number of story pages in the comic
    let urls: [MarvelURL] // A set of public web site URLs for the resource
    let thumbnail: MarvelImage // The representative image for this comic
    let images: [MarvelImage] // A list of promotional images associated with this comic
    
    // MARK: - Syntactic Sugar
    
    var description_: String { description != nil ? description! : "Default Description for Comic" }
    
    var modified_: String {
        let date = ISO8601DateFormatter().date(from: modified) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: date)
    }
    
    static func == (lhs: ComicInfo, rhs: ComicInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct ComicFilter: MarvelFilter {
    typealias Request = ComicInfoRequest
    typealias CardView = ComicCardView
    var format: String?
    var formatType: String?
    var dateDescriptor: String?
    var title: String?
    var titleStartsWith: String?
    var startYear: Int?
    var isbn: String?
    var modifiedSince: String?
    var creatorId: Int?
    var characterId: Int?
    var seriesId: Int?
    var eventId: Int?
    var storyId: Int?
    var orderBy: String?
}

final class ComicInfoRequest: MarvelRequest<ComicFilter, ComicInfo>, InfoRequest {
    
    static var requests = [ComicFilter:ComicInfoRequest]()
    
    override var query: String {
        var request = "comics?"
        request.addMarvelArgument("format", filter?.format)
        request.addMarvelArgument("formatType", filter?.formatType)
        request.addMarvelArgument("dateDescriptor", filter?.dateDescriptor)
        request.addMarvelArgument("title", filter?.title)
        request.addMarvelArgument("titleStartsWith", filter?.titleStartsWith)
        request.addMarvelArgument("startYear", filter?.startYear)
        request.addMarvelArgument("isbn", filter?.isbn)
        request.addMarvelArgument("modifiedSince", filter?.modifiedSince)
        request.addMarvelArgument("creators", filter?.creatorId)
        request.addMarvelArgument("characters", filter?.characterId)
        request.addMarvelArgument("series", filter?.seriesId)
        request.addMarvelArgument("events", filter?.eventId)
        request.addMarvelArgument("stories", filter?.storyId)
        request.addMarvelArgument("orderBy", filter?.orderBy)
        request.addMarvelArgument("limit", max(1, min(limit, 100)))
        request.addMarvelArgument("offset", offset)
        return request
    }
}
