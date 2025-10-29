//
//  MyWatchListTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 13/10/2025.
//

import XCTest
import CoreData
@testable import MyWatchList

class MyWatchListBaseTestCase: XCTestCase {
    var dataManager: DataManager!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataManager = DataManager(inMemory: true)
        managedObjectContext = dataManager.container.viewContext
    }
}
