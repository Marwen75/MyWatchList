//
//  MockNotifiableItem.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import Foundation
import CoreData
@testable import MyWatchList

final class MockNotifiableItem: NotifiableItem {
    let objectID: NSManagedObjectID
    let titleForNotification: String
    let itemReminderDate: Date
    var itemReminderEnabled: Bool

    init(context: NSManagedObjectContext, title: String = "Test Movie", reminderDate: Date = Date().addingTimeInterval(3600), enabled: Bool = true) {
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)

        self.objectID = managedObject.objectID
        self.titleForNotification = title
        self.itemReminderDate = reminderDate
        self.itemReminderEnabled = enabled
    }
}
