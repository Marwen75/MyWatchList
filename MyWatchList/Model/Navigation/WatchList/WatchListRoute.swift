//
//  WatchListRoute.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import Foundation
import CoreData

enum WatchListRoute: Hashable {
    case movieDetails(movie: Movie)
    case tvShowDetails(tvShow: TvShow)
    case seasonDetails(season: ShowSeason)
    case episodeDetails(episode: ShowEpisode)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: WatchListRoute, rhs: WatchListRoute) -> Bool {
        switch (lhs, rhs) {
        case (.movieDetails(let lhsMovie), .movieDetails(let rhsMovie)):
            return lhsMovie.id == rhsMovie.id
        case (.tvShowDetails(let lhsShow), .tvShowDetails(let rhsTvShow)):
            return lhsShow.id == rhsTvShow.id
        case (.seasonDetails(let lhsSeason), .seasonDetails(let rhsSeason)):
            return lhsSeason.id == rhsSeason.id
        case (.episodeDetails(let lhsEp), .episodeDetails(let rhsEp)):
            return lhsEp.id == rhsEp.id
        default:
            return false
        }
    }
}
