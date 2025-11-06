//
//  NotifiableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import Foundation
import CoreData

protocol NotifiableItem {
    var objectID: NSManagedObjectID { get }
    var titleForNotification: String { get }
    var itemReminderDate: Date { get }
    var itemReminderEnabled: Bool { get set }
}
