//
//  AlertContext.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import Foundation

struct AlertContext: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    var primaryButtonTitle = "Ok"
    var primaryAction: (() -> Void)? = nil
}
