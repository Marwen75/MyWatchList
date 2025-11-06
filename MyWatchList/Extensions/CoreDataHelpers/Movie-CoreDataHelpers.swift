//
//  Movie-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

extension Movie {
    var movieId: Int {
        Int(id)
    }
    
    var movieTitle: String {
        title ?? ""
    }
    
    var movieBudget: Int {
        Int(budget)
    }
    
    var movieOverview: String {
        overview ?? ""
    }
    
    var movieImdbUrl: String {
        imdbUrl ?? ""
    }
    
    var movieReleaseDate: String {
        releaseDate ?? ""
    }
    
    var moviePoster: String {
        poster ?? ""
    }
    
    var movieTrailer: String {
        trailerUrl ?? ""
    }
    
    var movieVoteAverage: String {
        String(format: "%.1f", voteAverage)
    }
    
    var movieRuntime: Int {
        Int(runTime)
    }
    
    var movieGenres: String {
        genres ?? "N/A"
    }
    
    /// Needed to get rid of the core data NSSet and get an array of tags instead
    var movieTags: [Tag] {
        let arrayOfTags = tags?.allObjects as? [Tag] ?? []
        return arrayOfTags.sorted()
    }
    
    /// Return a list of tag names to display 
    var movieTagsList: String {
        guard let tags else { return NSLocalizedString("No tags", comment: "No tags") }

        if tags.count == 0 {
            return NSLocalizedString("No tags", comment: "No tags")
        } else {
            return movieTags.map(\.tagName).formatted()
        }
    }
    
    var movieDirectors: [Director] {
        let arrayOfDirectors = directors?.allObjects as? [Director] ?? []
        return arrayOfDirectors.sorted { $0.directorName < $1.directorName }
    }
    
    var movieActors: [Actor] {
        let arrayOfActors = actors?.allObjects as? [Actor] ?? []
        return arrayOfActors.sorted { ac, act in
            ac.rank < act.rank
        }
    }
    
    var movieReminderDate: Date {
        get { reminderDate ?? .now }
        set { reminderDate = newValue }
    }
}

extension Movie: WatchableItem {
    var titleForNotification: String {
        movieTitle
    }
    
    var itemReminderDate: Date {
        movieReminderDate
    }
    
    var itemReminderEnabled: Bool {
        get { reminderEnabled }
        set { reminderEnabled = newValue }
    }
    
    var itemTitle: String {
        movieTitle
    }
    
    var itemPosterPath: String {
        moviePoster
    }
    
    var trailerPath: String {
        movieTrailer
    }
    
    var itemActors: [Actor] {
        movieActors
    }
    
    var itemCredits: [Director] {
        movieDirectors
    }
    
    var crewLabelSingular: String {
        NSLocalizedString("Director", comment: "")
    }
    
    var crewLabelPlural: String {
        NSLocalizedString("Directors", comment: "")
    }
    
    var itemGenres: String {
        movieGenres
    }
    
    var itemOverview: String {
        movieOverview
    }
    
    var itemRating: String {
        movieVoteAverage == "0" ? "N/A" : "\(movieVoteAverage)/10"
    }
}

extension Movie: Comparable {
    public static func < (lhs: Movie, rhs: Movie) -> Bool {
        lhs.movieTitle.lowercased() < rhs.movieTitle.lowercased()
    }
}
