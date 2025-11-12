//
//  WatchListContentListView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/11/2025.
//

import SwiftUI

struct WatchListContentListView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var watchListViewModel: WatchListViewModel
    
    var body: some View {
        if watchListViewModel.selectedFilter?.typeOfContent == .movies {
            List(selection: $watchListViewModel.selectedMovie) {
                Section("Not seen yet:") {
                    ForEach(watchListViewModel.notWatchedMovies, id: \.self) { movie in
                        MovieListRow(movie: movie)
                            .accessibilityIdentifier("movie_\(movie.id)")
                    }
                    .onDelete(perform: watchListViewModel.deleteMovie)
                    .listRowBackground(Color.clear)
                }
                .sectionTitleStyle()
                
                Section("Watched:") {
                    ForEach(watchListViewModel.watchedMovies, id: \.self) { movie in
                        MovieListRow(movie: movie)
                    }
                    .onDelete(perform: watchListViewModel.deleteMovie)
                    .listRowBackground(Color.clear)
                }
                .sectionTitleStyle()
            }
            .accessibilityIdentifier("mainMovieList")
        } else {
            List(selection: $watchListViewModel.selectedShow) {
                Section("Not seen yet:") {
                    ForEach(watchListViewModel.notWatchedShows, id: \.self) { show in
                        TvShowListRow(show: show)
                    }
                    .onDelete(perform: watchListViewModel.deleteTvShow)
                    .listRowBackground(Color.clear)
                }
                .sectionTitleStyle()
                
                Section("Watched:") {
                    ForEach(watchListViewModel.watchedShows, id: \.self) { show in
                        TvShowListRow(show: show)
                    }
                    .onDelete(perform: watchListViewModel.deleteTvShow)
                    .listRowBackground(Color.clear)
                }
                .sectionTitleStyle()
            }
        }
    }
}

#Preview {
    WatchListContentListView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview))
}
