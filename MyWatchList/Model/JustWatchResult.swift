//
//  JustWatchResult.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct JustWatchResult: Codable {
    let description: [JustWatchContent]
}

struct JustWatchContent: Codable, Identifiable {
    let id: String
    let type: TypeEnum
    let url: String
    let title: String
    let year, runtime: Int
    let photoURL, backdrops: [String]
    let tmdbID: String
    let imdbID: String?
    let jwRating: Double?
    let tomatoMeter: Int?
    let tomatoCertifiedFresh: Bool?
    let offers: [Offer]

    enum CodingKeys: String, CodingKey {
        case id, type, url, title, year, runtime
        case photoURL = "photo_url"
        case backdrops
        case tmdbID = "tmdbId"
        case imdbID = "imdbId"
        case jwRating, tomatoMeter, tomatoCertifiedFresh, offers
    }
}

// MARK: - Offer
struct Offer: Codable {
    let type, name: String
    let url: String
}

enum TypeEnum: String, Codable {
    case movie = "MOVIE"
    case show = "SHOW"
}
