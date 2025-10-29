//
//  MyWatchListApp.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

@main
struct MyWatchListApp: App {
#if DEBUG
    @State var networkManager = NetworkManager(environment: .testing)
#else
    @State var networkManager = NetworkManager(environment: .production)
#endif
    @StateObject var dataManager = DataManager()
    
    #if os(iOS)
    init() {
        if CommandLine.arguments.contains("enable-testing") {
            // Deactivate animations for ui testing
            UIView.setAnimationsEnabled(false)
        }
    }
    #endif
    
    var body: some Scene {
        WindowGroup {
            HomeView(dataManager: dataManager)
                .environment(\.networkManager, networkManager)
                .environment(\.managedObjectContext, dataManager.container.viewContext)
                .environmentObject(dataManager)
        }
    }
}

enum Tabs: Equatable, Hashable {
    case userContent
    case search
}
