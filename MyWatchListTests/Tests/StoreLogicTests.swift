//
//  StoreLogicTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 12/11/2025.
//

import XCTest
@testable import MyWatchList

final class StoreLogicTests: MyWatchListBaseTestCase {
    
    override func tearDownWithError() throws {
        dataManager = nil
    }
    
    func testFullAppPurchasedShouldPersistInDefaults() throws {
        let defaults = dataManager.defaults
        
        XCTAssertFalse(dataManager.fullAppPurchased, "fullAppPurchased should start as false")
        
        dataManager.fullAppPurchased = true
        XCTAssertTrue(dataManager.fullAppPurchased, "fullAppPurchased should become true")
        
        let newManager = DataManager(inMemory: true, defaults: defaults)
        XCTAssertTrue(newManager.fullAppPurchased, "fullAppPurchased should persist in UserDefaults")
    }
    
    @MainActor
    func testAddNewTagShouldTriggerStoreViewWhenLimitExceeded() throws {
        let vm = WatchListViewModel(dataManager: dataManager)
        
        for _ in 0..<3 {
            _ = dataManager.newTag(isMovieTag: true, name: "")
        }
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), 3, "There should be 3 tags before the limitation.")
        
        vm.tryNewTag(isMovieTag: true)
        
        XCTAssertTrue(vm.showingStore, "Store view should be presented after exceeding free tag limit.")
    }
    
    func testSimulatedPurchaseShouldSetFullAppPurchasedFlag() throws {
        let defaults = dataManager.defaults

        XCTAssertFalse(defaults.bool(forKey: "fullAppPurchased"))
        dataManager.fullAppPurchased = true

        XCTAssertTrue(defaults.bool(forKey: "fullAppPurchased"))
        XCTAssertTrue(dataManager.fullAppPurchased)
    }
}
