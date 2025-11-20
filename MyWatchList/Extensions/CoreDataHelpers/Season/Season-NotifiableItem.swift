//
//  Season-NotifiableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 13/11/2025.
//

import Foundation
import CoreData

extension ShowSeason: NotifiableItem {
    var seasonReminderDate: Date {
        get { reminderDate ?? .now }
        set { reminderDate = newValue }
    }
    
    var titleForNotification: String {
        if let show = tvShow {
            "\(show.showTitle), \(seasonName)"
        } else {
            seasonName
        }
    }
    
    var itemReminderDate: Date {
        seasonReminderDate
    }
    
    var itemReminderEnabled: Bool {
        get { reminderEnabled }
        set { reminderEnabled = newValue }
    }
}
