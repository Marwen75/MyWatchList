//
//  ImdbResult.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct ImdbResult: Codable {
    let description: [ImdbContent]
}

struct ImdbContent: Codable, Identifiable {
    var title: String
    let year: Int?
    let id: String
    let actors, aka: String
    let imdbURL: String
    let imgPoster: String?

    enum CodingKeys: String, CodingKey {
        case title = "#TITLE"
        case year = "#YEAR"
        case id = "#IMDB_ID"
        case actors = "#ACTORS"
        case aka = "#AKA"
        case imdbURL = "#IMDB_URL"
        case imgPoster = "#IMG_POSTER"
    }
}
