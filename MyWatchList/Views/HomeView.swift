//
//  HomeView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import SwiftUI
import CoreSpotlight

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
                    SidebarView(watchListViewModel: watchListViewModel)
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
            .accessibilityIdentifier("wlTab")
            
            Tab("Search", systemImage: "plus.magnifyingglass", value: .search) {
                SearchView(dataManager: dataManager, networkManager: networkManager)
                    .environmentObject(searchPathManager)
            }
            .accessibilityIdentifier("schTab")
        }
        .tint(.yellow)
        .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
        .onOpenURL(perform: openURL)
    }
    
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            if let movie = dataManager.movie(with: uniqueIdentifier) {
                dataManager.selectedFilter = .movies
                dataManager.selectedMovie = movie
#if os(iOS)
                watchListPathManager.push(to: .movieDetails(movie: movie))
#endif
            } else if let tvShow = dataManager.tvShow(with: uniqueIdentifier) {
                dataManager.selectedFilter = .tvShows
                dataManager.selectedShow = tvShow
#if os(iOS)
                watchListPathManager.push(to: .tvShowDetails(tvShow: tvShow))
#endif
            }
        }
    }
    
    func openURL(_ url: URL) {
        if let movie = dataManager.movie(with: url.absoluteString) {
            dataManager.selectedFilter = .movies
            dataManager.selectedMovie = movie
#if os(iOS)
            watchListPathManager.push(to: .movieDetails(movie: movie))
#endif
        } else if let tvShow = dataManager.tvShow(with: url.absoluteString) {
            dataManager.selectedFilter = .tvShows
            dataManager.selectedShow = tvShow
#if os(iOS)
            if let unwatchedSeason = tvShow.showSeasons.first(where: {!$0.watched}), let nextEpisodeToWatch = unwatchedSeason.seasonEpisodes.first(where: {!$0.watched}) {
                watchListPathManager.push(to: .episodeDetails(episode: nextEpisodeToWatch))
            } else {
                watchListPathManager.push(to: .tvShowDetails(tvShow: tvShow))
            }
#endif
        }
    }
}

enum Tabs: Equatable, Hashable {
    case userContent
    case search
}

#Preview {
    HomeView(dataManager: DataManager.preview)
        .environmentObject(DataManager.preview)
}
