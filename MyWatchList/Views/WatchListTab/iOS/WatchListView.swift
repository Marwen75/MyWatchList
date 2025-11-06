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
                VStack {
                    if watchListViewModel.selectedFilter?.typeOfContent == .movies {
                        List(selection: $watchListViewModel.selectedMovie) {
                            Section("Not seen yet:") {
                                ForEach(watchListViewModel.dataManager.fetchMovies().filter {!$0.watched}, id: \.self) { movie in
                                    MovieListRow(movie: movie)
                                        .accessibilityIdentifier("movie_\(movie.id)")
                                }
                                .onDelete(perform: watchListViewModel.deleteMovie)
                                .listRowBackground(Color.black.opacity(0))
                            }
                            .sectionTitleStyle()
                            
                            Section("Watched:") {
                                ForEach(watchListViewModel.dataManager.fetchMovies().filter {$0.watched}, id: \.self) { movie in
                                    MovieListRow(movie: movie)
                                }
                                .onDelete(perform: watchListViewModel.deleteMovie)
                                .listRowBackground(Color.black.opacity(0))
                            }
                        }
                        .accessibilityIdentifier("mainMovieList")
                        .padding(.leading)
                        .listStyle(.plain)
                        .searchable(text: $watchListViewModel.searchText, prompt: "Filter by name, genres, actors etc")
                        .toolbar {
                            ToolbarItem {
                                WatchListViewMenuToolbar()
                            }
                        }
                    } else {
                        List(selection: $watchListViewModel.selectedShow) {
                            Section("Not seen yet:") {
                                ForEach(watchListViewModel.dataManager.fetchTvShows().filter {!$0.watched}, id: \.self) { show in
                                    TvShowListRow(show: show)
                                }
                                .onDelete(perform: watchListViewModel.deleteTvShow)
                                .listRowBackground(Color.black.opacity(0))
                            }
                            
                            Section("Watched:") {
                                ForEach(watchListViewModel.dataManager.fetchTvShows().filter {$0.watched}, id: \.self) { show in
                                    TvShowListRow(show: show)
                                }
                                .onDelete(perform: watchListViewModel.deleteTvShow)
                                .listRowBackground(Color.black.opacity(0))
                            }
                        }
                        .padding(.leading)
                        .listStyle(.plain)
                        .searchable(text: $watchListViewModel.searchText, prompt: "Filter by name, genres, actors etc")
                        .toolbar {
                            ToolbarItem {
                                WatchListViewMenuToolbar()
                            }
                        }
                    }
                }
                .onChange(of: watchListViewModel.appError) { _, newError in
                    if let error = newError {
                        errorManager.present(error)
                    }
                }
                .navigationTitle(watchListViewModel.selectedFilter?.name ?? "")
                .navigationSubtitle(watchListViewModel.selectedFilter?.typeOfContent == .movies ? "\(watchListViewModel.dataManager.fetchMovies().count) results" : "\(watchListViewModel.dataManager.fetchTvShows().count) results")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $watchListViewModel.presentFilterSheet) {
                    SmartFilterView(watchListViewModel: watchListViewModel)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            watchListViewModel.presentFilterSheet.toggle()
                        } label: {
                            if watchListViewModel.selectedFilter == .movies {
                                Image(systemName: "film")
                            } else if watchListViewModel.selectedFilter == .tvShows {
                                Image(systemName: "tv")
                            } else {
                                Image(systemName: "tag")
                            }
                        }
                    }
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
