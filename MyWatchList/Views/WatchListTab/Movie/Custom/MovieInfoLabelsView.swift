//
//  MovieInfoLabelsView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import SwiftUI

struct MovieInfoLabelsView: View {
    @ObservedObject var movie: Movie
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Label("\(movie.movieReleaseDate)", systemImage: "calendar")
                Spacer()
                Label(movie.movieBudget == 0 ? "N/A" : "\(movie.movieBudget)", systemImage: "dollarsign.circle")
            }
            
            HStack {
                Label("\(movie.movieRuntime, default: "N/A") minutes", systemImage: "clock")
                Spacer()
                Label(movie.movieVoteAverage == "0" ? "N/A" : movie.movieVoteAverage + "/10", systemImage: "star.circle")
            }
        }
        .infoStyle()
    }
}

#Preview {
    MovieInfoLabelsView(movie: .example)
}
