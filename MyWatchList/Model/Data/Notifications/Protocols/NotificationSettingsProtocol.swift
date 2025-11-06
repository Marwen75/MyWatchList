//
//  NotificationSettingsProtocol.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import Foundation
import UserNotifications

protocol NotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus { get }
}

extension UNNotificationSettings: NotificationSettingsProtocol {}
