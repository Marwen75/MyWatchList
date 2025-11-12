//
//  DataManager-Notifications.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 03/11/2025.
//

import Foundation
import UserNotifications

extension DataManager {
    /// Schedules a local notification reminder for an item conforming to NotifiableItem
    /// - Parameters:
    ///   - item: The notifiable item for which the reminder should be created
    ///   - center: The notification center used to request permissions and schedule notifications. Defaults to 'UNUserNotificationCenter.current().
    /// - Returns: True if the reminder was successfully scheduled, false if it was not.
    func addReminder<T: NotifiableItem>(for item: T, center: UserNotificationCenterProtocol = UNUserNotificationCenter.current()) async -> Bool {
        guard item.itemReminderEnabled else { return false }
        
        do {
            let settings = await center.fetchNotificationSettings()

            switch settings.authorizationStatus {
            case .notDetermined:
                let success = try await requestNotifications(center: center)
                
                if success {
                    try await placeReminders(for: item, center: center)
                } else {
                    return false
                }
            case .authorized:
                try await placeReminders(for: item, center: center)
            default:
                return false
            }
            return true
        } catch {
            return false
        }
    }
    
    /// Removes any pending notifications associated with the item.
    /// - Parameters:
    ///   - item: The notifiable item whose reminders should be removed.
    ///   - center: The notification center used to remove the pending notification requests. Defaults to 'UNUserNotificationCenter.current().
    func removeReminders<T: NotifiableItem>(for item: T, center: UserNotificationCenterProtocol = UNUserNotificationCenter.current()) {
        let id = item.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    /// Requests authorization from the user to send local notifications
    /// - Parameter center: The notification center used to request authorization.
    /// - Returns: True if the user granted permission, false otherwise.
    private func requestNotifications(center: UserNotificationCenterProtocol) async throws -> Bool {
        return try await center.requestAuthorization(options: [.alert, .sound])
    }
    
    /// Creates and schedules a notification for the given notifiable item.
    /// - Parameters:
    ///   - item: The notifiable item for which the notification should be created and scheduled
    ///   - center: The notification center used to schedule the notification. Defaults to 'UNUserNotificationCenter.current().
    private func placeReminders<T: NotifiableItem>(for item: T, center: UserNotificationCenterProtocol = UNUserNotificationCenter.current()) async throws {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = NSLocalizedString("Reminder!", comment: "Notification title")
        content.subtitle = String(format: NSLocalizedString("Watch %@", comment: "Notification subtitle"), item.titleForNotification)
        
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: item.itemReminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let id = item.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await center.add(request)
    }
}
