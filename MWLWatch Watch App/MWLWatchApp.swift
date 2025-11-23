//
//  MWLWatchApp.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 21/11/2025.
//

import SwiftUI

@main
struct MWLWatch_Watch_AppApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchHomeView()
            }
            .environmentObject(dataManager)
        }
    }
}
