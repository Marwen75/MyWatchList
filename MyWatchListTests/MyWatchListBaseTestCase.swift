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
        let suiteName = "TestDefaults_\(UUID().uuidString)"
        let testDefaults = UserDefaults(suiteName: suiteName)!
        testDefaults.removePersistentDomain(forName: suiteName)
        
        dataManager = DataManager(inMemory: true, defaults: testDefaults)
        managedObjectContext = dataManager.container.viewContext
    }
}
