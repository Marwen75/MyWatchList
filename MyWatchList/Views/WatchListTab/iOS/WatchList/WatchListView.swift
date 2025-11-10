//
//  WatchListView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

#if os(iOS)
import SwiftUI

struct WatchListView: View {
    @EnvironmentObject var watchListPathManager: WatchListPathManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var errorManager: ErrorManager
    @ObservedObject var watchListViewModel: WatchListViewModel
    
    var body: some View {
        NavigationStack(path: $watchListPathManager.routes) {
            ZStack {
                LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                WatchListContentListView(watchListViewModel: watchListViewModel)
                    .padding(.leading)
                    .listStyle(.plain)
                    .searchable(text: $watchListViewModel.searchText, prompt: "Filter by name, genres, actors etc")
            }
            .onChange(of: watchListViewModel.appError) { _, newError in
                if let error = newError {
                    errorManager.present(error)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $watchListViewModel.presentFilterSheet) {
                SmartFilterView(watchListViewModel: watchListViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(watchListViewModel.selectedFilter?.name ?? "My WatchList")
                            .font(.system(size: 18, weight: .heavy, design: .monospaced))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .truncationMode(.tail)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    WatchListViewSortingToolbar()
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        watchListViewModel.presentFilterSheet.toggle()
                    } label: {
                        if watchListViewModel.selectedFilter == .movies {
                            Image(systemName: Filter.movies.icon)
                        } else if watchListViewModel.selectedFilter == .tvShows {
                            Image(systemName: Filter.tvShows.icon)
                        } else {
                            Image(systemName: "tag")
                        }
                    }
                }
                ToolbarItem {
                    WatchListViewMenuToolbar()
                }
            }
            .navigationDestination(for: WatchListRoute.self) { route in
                switch route {
                case .movieDetails(let movie):
                    MovieView(movie: movie, dataManager: dataManager)
                case .tvShowDetails(let tvShow):
                    TvShowView(tvShow: tvShow, dataManager: dataManager)
                case .seasonDetails(let season):
                    TvShowSeasonDetailView(season: season, dataManager: dataManager)
                case .episodeDetails(let episode):
                    EpisodeDetailView(episode: episode, dataManager: dataManager)
                }
            }
        }
    }
}

#Preview {
    WatchListView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview))
        .environmentObject(WatchListPathManager())
        .environmentObject(DataManager.preview)
}
#endif
