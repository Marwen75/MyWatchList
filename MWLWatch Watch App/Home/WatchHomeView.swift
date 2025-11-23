//
//  WatchHomeView.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 21/11/2025.
//

import SwiftUI

struct WatchHomeView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var movies: [Movie] = []
    @State private var shows: [TvShow] = []
    @State private var nextEpisode: ShowEpisode?
    
    var body: some View {
        List {
            if !movies.isEmpty {
                Section("Movies") {
                    ForEach(movies) { movie in
                        NavigationLink(destination: WatchMovieView(movie: movie)) {
                            HStack {
                                Text(movie.movieTitle)
                                    .font(.caption2)
                                    .fontDesign(.monospaced)
                                    .fontWeight(.thin)
                                    .foregroundStyle(movie.watched ? .white.opacity(0.35) : .white.opacity(0.9))
                                
                                Spacer()
                                
                                if movie.watched {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.white.opacity(0.4))
                                        .font(.caption2)
                                } else {
                                    Image(systemName: "film")
                                        .foregroundStyle(.white.opacity(0.6))
                                        .font(.caption2)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteMovie)
                }
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.leading, -8)
            }
            
            if !shows.isEmpty {
                Section("Tv Shows") {
                    ForEach(shows) { show in
                        NavigationLink(destination: WatchTvShowView(show: show)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(show.showTitle)
                                        .font(.caption2)
                                        .fontDesign(.monospaced)
                                        .fontWeight(.thin)
                                        .foregroundStyle(show.watched ? .white.opacity(0.35) : .white.opacity(0.9))
                                    
                                    if let ep = show.nextUnwatchedEpisode() {
                                        Text(ep.formattedNextEp)
                                            .font(.footnote)
                                            .fontDesign(.monospaced)
                                            .fontWeight(.ultraLight)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                WatchCircularProgressView(progress: show.showProgress, width: 26, height: 26)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteShow)
                }
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.leading, -8)
            }
        }
        .scrollContentBackground(.hidden)
        .background(LinearGradient(colors: [.darkRed, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
        .navigationTitle("MyWatchList")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadData)
    }
    
    private func loadData() {
        movies = dataManager.fetchMovies()
        shows = dataManager.fetchTvShows()
    }
    
    private func deleteMovie(atOffsets offsets: IndexSet) {
        for offset in offsets {
            dataManager.delete(movies[offset])
        }
        loadData()
    }
    
    private func deleteShow(atOffsets offsets: IndexSet) {
        for offset in offsets {
            dataManager.delete(shows[offset])
        }
        loadData()
    }
}

#Preview {
    NavigationStack {
        WatchHomeView()
            .environmentObject(DataManager.preview)
    }
}
