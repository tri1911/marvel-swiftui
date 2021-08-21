//
//  MarvelRequest+CreatorInfo.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-15.
//

import Foundation

struct CreatorInfo: Codable, Identifiable, Hashable {
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
    
    static func == (lhs: CreatorInfo, rhs: CreatorInfo) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
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

final class CreatorInfoRequest: MarvelRequest<CreatorFilter, CreatorInfo>, InfoRequest {
    
    static var requests = [CreatorFilter:CreatorInfoRequest]()
    
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
}
