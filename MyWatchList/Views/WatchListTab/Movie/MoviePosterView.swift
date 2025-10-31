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
        PosterImageView(path: movie.moviePoster, size: .flexible(maxHeight: 650))
    }
}

#Preview {
    MoviePosterView(movie: .example)
}
