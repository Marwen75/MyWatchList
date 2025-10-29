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
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Form {
                Section(movie.movieTitle) {
                    BigPosterImageView(maxHeight: 700, path: movie.moviePoster)
                    
                    MoviePriorityAndTagView(movie: movie)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                
                Section("Informations") {
                    MovieMainInfoView(movie: movie)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                
                Section("Trailer") {
                    MovieTrailerView(movie: movie)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                
                Section("Cast") {
                    MovieCastView(movie: movie)
                        .frame(minHeight: 100)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
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
