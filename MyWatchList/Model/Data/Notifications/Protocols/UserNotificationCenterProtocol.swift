//
//  UserNotificationCenterProtocol.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import Foundation
import UserNotifications

protocol UserNotificationCenterProtocol {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func fetchNotificationSettings() async -> NotificationSettingsProtocol
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

extension UNUserNotificationCenter: UserNotificationCenterProtocol {
    func fetchNotificationSettings() async -> any NotificationSettingsProtocol {
        await self.notificationSettings()
    }
}
