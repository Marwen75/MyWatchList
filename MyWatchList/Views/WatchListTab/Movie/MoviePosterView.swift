//
//  MoviePosterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct MoviePosterView: View {
    @ObservedObject var movie: Movie
    
    var body: some View {
        BigPosterImageView(maxHeight: 650, path: movie.moviePoster)
    }
}

#Preview {
    MoviePosterView(movie: .example)
}
