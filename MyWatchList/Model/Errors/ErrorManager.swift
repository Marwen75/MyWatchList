//
//  ErrorManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI

/// A global and observable error manager thath allows to trigger alerts throughout the app
@MainActor
class ErrorManager: ObservableObject {
    @Published var alertContext: AlertContext?
    
    /// Presents an alert for a given AppError.
    /// - Parameters:
    ///   - error: The AppError to present.
    ///   - title: A custom title for the alert. Defaults to 'Oups'.
    func present(_ error: AppError, title: String = "Oups!") {
        switch error {
        case .permissionDenied:
            alertContext = AlertContext(title: title, message: error.errorDescription ?? "",
                                        primaryButtonTitle: NSLocalizedString("Check settings", comment: ""), primaryAction: openAppSettings)
        default:
            alertContext = AlertContext(title: title, message: error.errorDescription ?? NSLocalizedString("An unexpected error occured.", comment: ""))
        }
    }
    
    /// Converts a generic Error to an AppError and presents it to the user.
    /// - Parameters:
    ///   - error: The generic Error to convert.
    ///   - title: A custom title. Defaults to 'Oups'.
    func present(_ error: Error, title: String = "Oups!") {
        let appError = AppError(error)
        present(appError, title: title)
    }
    
    /// Dismisses any currently displayed alert.
    func dismiss() {
        alertContext = nil
    }
    
    /// Opens the app's notification settings in the system Settings app.
    private func openAppSettings() {
#if os(iOS)
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
#else
        if let url = URL(string: "x-apple.systempreferences:com.apple.Notifications-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
#endif
    }
}
