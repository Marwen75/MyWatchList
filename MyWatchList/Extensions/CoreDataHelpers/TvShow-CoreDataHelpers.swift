//
//  TvShow-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 22/09/2025.
//

import SwiftUI

extension TvShow {
    var showId: Int {
        Int(id)
    }
    
    var showTitle: String {
        title ?? ""
    }
    
    var showFirstAirDate: String {
        firstAirDate ?? ""
    }
    
    var showLastAirDate: String {
        lastAirDate ?? ""
    }
    
    var showOverview: String {
        overview ?? ""
    }
    
    var showImdbUrl: String {
        imdbUrl ?? ""
    }
    
    var showInProduction: Bool {
        inProduction
    }
    
    var showGenres: String {
        genres ?? ""
    }
    
    var showPoster: String {
        poster ?? ""
    }
    
    var showTrailer: String {
        trailerUrl ?? ""
    }
    
    var showVoteAverage: String {
        String(format: "%.1f", voteAverage)
    }
    
    var showNumberOfEpisodes: Int {
        Int(numberOfEpisodes)
    }
    
    /// Needed to get rid of the core data NSSet and get an array of tags instead
    var showTags: [Tag] {
        let arrayOfTags = tags?.allObjects as? [Tag] ?? []
        return arrayOfTags.sorted()
    }
    
    /// Return a list of tag names to display
    var showTagsList: String {
        guard let tags else { return NSLocalizedString("No tags", comment: "No tags") }

        if tags.count == 0 {
            return NSLocalizedString("No tags", comment: "No tags")
        } else {
            return showTags.map(\.tagName).formatted()
        }
    }
    
    /// Return the array of showrunners for the show
    var showDirectors: [Director] {
        let arrayOfDirectors = directors?.allObjects as? [Director] ?? []
        return arrayOfDirectors
    }
    
    /// Return the array of actors for a show
    var showActors: [Actor] {
        let arrayOfActors = actors?.allObjects as? [Actor] ?? []
        return arrayOfActors.sorted { $0.rank < $1.rank }
    }
    
    var showSeasons: [ShowSeason] {
        let arrayOfSeasons = seasons?.allObjects as? [ShowSeason] ?? []
        return arrayOfSeasons.sorted { $0.rank < $1.rank }
    }
    
    var allSeasonsWatched: Bool {
        for season in showSeasons {
            if !season.watched {
                return false
            }
        }
        return true
    }
    
    var numberOfEpisodesWatched: Int {
        var numberOfEpisodes = 0
        if allSeasonsWatched {
            return showNumberOfEpisodes
        }
        for season in showSeasons {
            for episode in season.seasonEpisodes {
                if episode.watched {
                    numberOfEpisodes += 1
                }
            }
        }
        return numberOfEpisodes
    }
    
    var showProgress: Double {
        Double(numberOfEpisodesWatched) / Double(showNumberOfEpisodes)
    }
}

extension TvShow: Comparable {
    public static func < (lhs: TvShow, rhs: TvShow) -> Bool {
        lhs.showTitle.lowercased() < rhs.showTitle.lowercased()
    }
}
