//
//  Movie-WatchableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import Foundation

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
    
    var itemPriority: Int16 {
       priority
    }
    
    var itemTagsList: String {
        movieTagsList
    }
    
    var itemWatched: Bool {
        watched
    }
}
