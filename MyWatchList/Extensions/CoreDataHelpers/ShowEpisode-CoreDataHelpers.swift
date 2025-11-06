//
//  ShowEpisode-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import Foundation

extension ShowEpisode: NotifiableItem {
    var episodeName: String {
        name ?? "N/A"
    }
    
    var episodeOverview: String {
        overview ?? "N/A"
    }
    
    var episodeStillPath: String {
        stillPath ?? ""
    }
    
    var episodeRunTime: Int {
        Int(runTime)
    }
    
    var episodeAirDate: String {
        airDate ?? "N/A"
    }
    
    var episodeVoteAverage: String {
        String(format: "%.1f", voteAverage)
    }
    
    var episodeReminderDate: Date {
        get { reminderDate ?? .now }
        set { reminderDate = newValue }
    }
    
    var titleForNotification: String {
        if let season = season, let show = season.tvShow {
            "\(show.showTitle), \(season.seasonName), \(NSLocalizedString("Episode", comment: "")): \(episodeName)"
        } else {
            episodeName
        }
    }
    
    var itemReminderDate: Date {
        episodeReminderDate
    }
    
    var itemReminderEnabled: Bool {
        get { reminderEnabled }
        set { reminderEnabled = newValue }
    }
}
