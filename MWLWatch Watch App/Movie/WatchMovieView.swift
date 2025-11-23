//
//  WatchMovieView.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 21/11/2025.
//

import SwiftUI

struct WatchMovieView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var movie: Movie
    
    @State private var overviewExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                WatchPosterView(posterPath: movie.moviePoster)
                
                Text(movie.movieReleaseDate)
                    .font(.footnote)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white.opacity(0.7))
                
                if movie.movieOverview != "" {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(overviewExpanded ? movie.movieOverview : String(movie.movieOverview.prefix(90) + "..."))
                            .font(.footnote)
                            .fontDesign(.monospaced)
                            .fontWeight(.thin)
                            .italic()
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Button(overviewExpanded ? "Show Less" : "Read More") {
                            withAnimation {
                                overviewExpanded.toggle()
                            }
                        }
                        .foregroundStyle(.white)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal)
                    
                    Button(action: markAsWatched) {
                        Text(movie.watched ? "Watched ✔︎" : "Mark as Watched")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(movie.watched ? .yellow : .darkGreen)
                    .padding(.top, 10)
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .navigationTitle(movie.movieTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .background(LinearGradient(colors: [.darkRed, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    private func markAsWatched() {
        withAnimation {
            movie.watched.toggle()
            dataManager.save()
        }
    }
}

#Preview {
    NavigationStack {
        WatchMovieView(movie: DataManager.preview.fetchMovies().first!)
            .environmentObject(DataManager.preview)
    }
}
