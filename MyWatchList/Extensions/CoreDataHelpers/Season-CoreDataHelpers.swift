//
//  Season-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import Foundation

extension ShowSeason {
    var seasonAirDate: String {
        return airDate ?? "N/A"
    }
    
    var seasonEpisodeCount: Int {
        return seasonEpisodes.count
    }
    
    var seasonId: Int {
        return Int(id)
    }
    
    var seasonName: String {
        return name ?? ""
    }
    
    var seasonPoster: String {
        return poster ?? ""
    }
    
    var seasonOverview: String {
        return overview ?? ""
    }
    
    var seasonVoteAverage: String {
        return String(format: "%.1f", voteAverage)
    }
    
    var seasonSeasNumber: Int {
        return Int(seasonNumber)
    }
    
    var seasonEpisodes: [ShowEpisode] {
        let arrayOfEpisodes = episodes?.allObjects as? [ShowEpisode] ?? []
        return arrayOfEpisodes.sorted { ep1, ep2 in
            ep1.rank < ep2.rank
        }
    }
    
    var allEpisodesWatched: Bool {
        for episode in seasonEpisodes {
            if !episode.watched {
                return false
            }
        }
        return true
    }
    
    var numberOfEpisodesWatched: Int {
        var numberOfEpisodes = 0
        if allEpisodesWatched {
            return seasonEpisodeCount
        }
        
        for episode in seasonEpisodes {
            if episode.watched {
                numberOfEpisodes += 1
            }
        }
        
        return numberOfEpisodes
    }
    
    var seasonProgress: Double {
        Double(numberOfEpisodesWatched) / Double(seasonEpisodeCount)
    }
}
