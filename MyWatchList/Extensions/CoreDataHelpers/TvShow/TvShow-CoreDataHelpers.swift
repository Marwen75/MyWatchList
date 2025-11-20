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
    
    var showReminderDate: Date {
        get { reminderDate ?? .now }
        set { reminderDate = newValue }
    }
    
    /// Returns the next episode that the user has not watched yet, based on the
    /// natural ordering of seasons and episode numbers.
    ///
    /// This method:
    /// 1. Gathers all seasons of the TV show.
    /// 2. Extracts all episodes across those seasons.
    /// 3. Filters out already-watched episodes.
    /// 4. Sorts them by (seasonNumber, episodeNumber).
    /// 5. Returns the earliest unwatched episode.
    ///
    /// This function is primarily used by the app and widgets to quickly identify
    /// the user's current progression in a TV show.
    ///
    /// - Returns: The next unwatched `ShowEpisode`, or `nil` if all episodes are watched.
    func nextUnwatchedEpisode() -> ShowEpisode? {
        // 1. Safely cast the Core Data relationship to the expected type.
        guard let allSeasons = seasons as? Set<ShowSeason> else { return nil }
        
        // 2. Flatten all episodes from all seasons into a single array.
        //    (Each season has an `episodes` relationship which is a Set as well.)
        let allEpisodes: [ShowEpisode] = allSeasons.flatMap { season in
            Array(season.episodes as? Set<ShowEpisode> ?? [])
        }
        
        // 3. Filter out watched episodes and sort the remaining ones
        //    by season number and episode number.
        let unwatched = allEpisodes
            .filter { !$0.watched }
            .sorted(by: { (a: ShowEpisode, b: ShowEpisode) -> Bool in
                // 4. Same season → sort by episode number
                if a.season == b.season {
                    return a.episodeNumber < b.episodeNumber
                } else { // 4. Different seasons → sort by seasonNumber
                    return a.season?.seasonNumber ?? 1 < b.season?.seasonNumber ?? 2
                }
            })
        
        // 5. The first episode in the sorted list is the next one to watch.
        return unwatched.first
    }
}

extension TvShow: Comparable {
    public static func < (lhs: TvShow, rhs: TvShow) -> Bool {
        lhs.showTitle.lowercased() < rhs.showTitle.lowercased()
    }
}
