//
//  MovieView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

import SwiftUI

struct MovieView: View {
    @ObservedObject var movie: Movie
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Form {
                Section(movie.movieTitle) {
                    PosterImageView(path: movie.moviePoster, size: .flexible(maxHeight: 700))
                    
                    MoviePriorityAndTagView(movie: movie)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Informations") {
                    MovieMainInfoView(movie: movie)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Trailer") {
                    MovieTrailerView(movie: movie)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Cast") {
                    MovieCastView(movie: movie)
                        .frame(minHeight: 100)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        MovieView(movie: .example)
            .environmentObject(DataManager.preview)
    }
}
