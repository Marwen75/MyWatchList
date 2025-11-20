//
//  TvShow-WatchableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import Foundation

extension TvShow: WatchableItem {
    var itemID: Int {
        showId
    }
    
    var titleForNotification: String {
        showTitle
    }
    
    var itemReminderDate: Date {
        showReminderDate
    }
    
    var itemReminderEnabled: Bool {
        get { reminderEnabled }
        set { reminderEnabled = newValue }
    }
    
    var itemTitle: String {
        showTitle
    }
    
    var itemPosterPath: String {
        showPoster
    }
    
    var trailerPath: String {
        showTrailer
    }
    
    var itemActors: [Actor] {
        showActors
    }
    
    var itemCredits: [Director] {
        showDirectors
    }
    
    var crewLabelSingular: String {
        NSLocalizedString("Creator", comment: "")
    }
    
    var crewLabelPlural: String {
        NSLocalizedString("Creators", comment: "")
    }
    
    var itemGenres: String {
        showGenres
    }
    
    var itemOverview: String {
        showOverview
    }
    
    var itemRating: String {
        showVoteAverage == "0" ? "N/A" : "\(showVoteAverage)/10"
    }
    
    var itemPriority: Int16 {
        priority
    }
    
    var itemTagsList: String {
        showTagsList
    }
    
    var itemWatched: Bool {
        watched
    }
}
