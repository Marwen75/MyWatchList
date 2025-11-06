//
//  NotificationsTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import XCTest
import UserNotifications
import CoreData
@testable import MyWatchList

final class NotificationsTests: MyWatchListBaseTestCase {
    var mockCenter: MockUserNotificationCenter!
    var mockItem: MockNotifiableItem!

    override func setUp() {
        super.setUp()
        mockCenter = MockUserNotificationCenter()
        mockItem = MockNotifiableItem(context: managedObjectContext)
    }

    override func tearDown() {
        mockCenter = nil
        mockItem = nil
        super.tearDown()
    }

    // MARK: - addReminder tests

    func testAddReminderWhenAuthorizedShouldAddNotification() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .authorized)

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertTrue(result)
        XCTAssertTrue(mockCenter.addCalled)
        XCTAssertFalse(mockCenter.authorizationRequested)
    }

    func testAddReminderWhenNotDeterminedAndUserGrantsShouldRequestAndAdd() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .notDetermined)
        mockCenter.shouldAuthorize = true

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertTrue(result)
        XCTAssertTrue(mockCenter.authorizationRequested)
        XCTAssertTrue(mockCenter.addCalled)
    }

    func testAddReminderWhenNotDeterminedAndUserDeniesShouldFail() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .notDetermined)
        mockCenter.shouldAuthorize = false

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertFalse(result)
        XCTAssertTrue(mockCenter.authorizationRequested)
        XCTAssertFalse(mockCenter.addCalled)
    }

    func testAddReminderWhenDeniedShouldReturnFalse() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .denied)

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertFalse(result)
        XCTAssertFalse(mockCenter.addCalled)
        XCTAssertFalse(mockCenter.authorizationRequested)
    }

    func testAddReminderWhenRequestAuthorizationThrowsShouldReturnFalse() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .notDetermined)
        mockCenter.shouldThrowError = true

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertFalse(result)
        XCTAssertTrue(mockCenter.authorizationRequested)
        XCTAssertFalse(mockCenter.addCalled)
    }

    func testAddReminderWhenAddThrowsShouldReturnFalse() async {
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .authorized)
        mockCenter.shouldThrowError = true

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertFalse(result)
        XCTAssertFalse(mockCenter.addCalled, "addCalled should remain false if add throws")
    }

    func testAddReminderWhenItemReminderDisabledShouldReturnFalse() async {
        mockItem.itemReminderEnabled = false
        mockCenter.settings = MockNotificationSettings(authorizationStatus: .authorized)

        let result = await dataManager.addReminder(for: mockItem, center: mockCenter)

        XCTAssertFalse(result, "Should not schedule reminder if reminder is disabled")
        XCTAssertFalse(mockCenter.addCalled)
    }

    // MARK: - removeReminders tests

    func testRemoveRemindersShouldRemovePendingRequests() {
        let expectedID = mockItem.objectID.uriRepresentation().absoluteString

        dataManager.removeReminders(for: mockItem, center: mockCenter)

        XCTAssertEqual(mockCenter.removedIdentifiers, [expectedID])
    }
}
