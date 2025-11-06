//
//  NotificationViewModel.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/11/2025.
//

import SwiftUI

@MainActor
class NotificationViewModel<T: NotifiableItem>: ObservableObject {
    @Published var appError: AppError?
    
    var dataManager: DataManager
    var item: T
    
    init(item: T, dataManager: DataManager) {
        self.item = item
        self.dataManager = dataManager
    }
    
    func updateReminder() async {
        dataManager.removeReminders(for: item)
        
        if item.itemReminderEnabled {
            let success = await dataManager.addReminder(for: item)
            if !success {
                item.itemReminderEnabled = false
                appError = .permissionDenied
            }
        }
    }
}
