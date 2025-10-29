//
//  TmdbResult.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 03/09/2025.
//

import Foundation

// MARK: - TmdbResult
struct TmdbResult: Codable {
    let page: Int
    let results: [TmdbContent]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TmdbContent
struct TmdbContent: Codable, Identifiable, Hashable {
    let creators: [Creator]?
    let budget: Int?
    let genres: [Genre]?
    let id: Int
    let imdbID: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let title: String?
    let name: String?
    let voteAverage: Double?
    let videos: Videos?
    let seasons: [Season]?
    let firstAirDate: String?
    let lastAirDate: String?
    let inProduction: Bool?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let episodeRunTime: [Int]?

    enum CodingKeys: String, CodingKey {
        case budget, genres, id, runtime, overview, title, videos, seasons, name
        case imdbID = "imdb_id"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case creators = "created_by"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case inProduction = "in_production"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case episodeRunTime = "episode_run_time"
    }
    
    /// We need the conformance to hashable protocol to enhance custom navigation
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TmdbContent, rhs: TmdbContent) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Creator
struct Creator: Codable, Identifiable {
    let id: Int
    let name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}

// MARK: - Season
struct Season: Codable, Identifiable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int
    let name, overview, posterPath: String?
    let seasonNumber: Int?
    let voteAverage: Double?
    let episodes: [Episode]? 

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview, episodes
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

// MARK: - Episode
struct Episode: Codable {
    let id: Int
    let name, overview, airDate, stillPath: String?
    let runtime, episodeNumber: Int?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, runtime
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
    }
}

// MARK: - Genre
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Videos
struct Videos: Codable {
    let results: [VideoInformation]
}

// MARK: - VideoInformation
struct VideoInformation: Codable {
    let id: String
    let name, key: String
    let site: Site
    let size: Int
    let type: String
    let official: Bool
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

// MARK: - Credits
struct Credits: Codable {
    let id: Int
    let cast, crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id, name, job
        case profilePath = "profile_path"
    }
}
