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
    
    @State var selectedTab: Tabs = .userContent
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                Tab("My Contents", systemImage: "list.bullet", value: .userContent) {
                    NavigationSplitView {
                        SidebarView()
                    } content: {
                        ContentView()
                    } detail: {
                        DetailView()
                    }
                }
                Tab("Search content", systemImage: "plus.magnifyingglass", value: .search) {
                    SearchView()
                }
            }
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
