//
//  ShowEpisode-NotifiableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 13/11/2025.
//

import Foundation
import CoreData

extension ShowEpisode: NotifiableItem {
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
