//
//  MockUserNotificationCenter.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import Foundation
import UserNotifications
@testable import MyWatchList

class MockUserNotificationCenter: UserNotificationCenterProtocol {
    var authorizationRequested = false
    var addCalled = false
    var removedIdentifiers: [String] = []
    var shouldAuthorize = true
    var shouldThrowError = false
    var settings: NotificationSettingsProtocol = MockNotificationSettings()
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        authorizationRequested = true
        if shouldThrowError {
            throw NSError(domain: "Test error", code: 1)
        }
        return shouldAuthorize
    }
    
    func fetchNotificationSettings() async -> NotificationSettingsProtocol{
        settings
    }
    
    func add(_ request: UNNotificationRequest) async throws {
        if shouldThrowError {
            throw NSError(domain: "Test error", code: 2)
        }
        addCalled = true
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removedIdentifiers = identifiers
    }
}

struct MockNotificationSettings: NotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus = .authorized
}
