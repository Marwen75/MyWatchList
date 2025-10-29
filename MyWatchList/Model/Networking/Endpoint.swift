//
//  Endpoint.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct Endpoint<T: Decodable> {
    var path: String
    var type: T.Type
    var method = HTTPMethod.get
}

extension Endpoint where T == TmdbContent {
    static let movieDetails = Endpoint(path: "movie", type: TmdbContent.self)
    static let tvShowDetails = Endpoint(path: "tv", type: TmdbContent.self)
}

extension Endpoint where T == TmdbResult {
    static let movies = Endpoint(path: "search/movie", type: TmdbResult.self)
    static let tvShows = Endpoint(path: "search/tv", type: TmdbResult.self)
}

extension Endpoint where T == Credits {
    static let movieCredits = Endpoint(path: "movie", type: Credits.self)
    static let showCredits = Endpoint(path: "tv", type: Credits.self)
}

extension Endpoint where T == Season {
    static let seasonDetails = Endpoint(path: "tv", type: Season.self)
}
