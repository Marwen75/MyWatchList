//
//  HomeView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject var watchListViewModel: WatchListViewModel
    @StateObject var searchPathManager = SearchPathManager()
    @StateObject var watchListPathManager = WatchListPathManager()
    
    @State var selectedTab: Tabs = .userContent
    
    init(dataManager: DataManager) {
        let viewModel = WatchListViewModel(dataManager: dataManager)
        _watchListViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Watch list", systemImage: "list.bullet", value: .userContent) {
#if os(macOS)
                NavigationSplitView {
                    SidebarView(sidebarViewViewModel: watchListViewModel)
                } content: {
                    ContentView(contentViewViewModel: watchListViewModel)
                } detail: {
                    if dataManager.selectedFilter?.typeOfContent == .movies {
                        if let selectedMovie = dataManager.selectedMovie {
                            DetailMovieView(movie: selectedMovie)
                        } else {
                            NoContentView()
                        }
                    } else {
                        if let selectedShow = dataManager.selectedShow {
                            DetailTvShowView(tvShow: selectedShow)
                        } else {
                            NoContentView()
                        }
                    }
                }
#else
                WatchListView(watchListViewModel: watchListViewModel)
                    .environmentObject(watchListPathManager)
                    .environmentObject(dataManager)
#endif
            }
            
            Tab("Search", systemImage: "plus.magnifyingglass", value: .search) {
                SearchView(dataManager: dataManager, networkManager: networkManager)
                    .environmentObject(searchPathManager)
            }
        }
    }
}

#Preview {
    HomeView(dataManager: DataManager.preview)
        .environmentObject(DataManager.preview)
}
