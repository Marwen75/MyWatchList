//
//  MovieTrailerView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 24/09/2025.
//

import SwiftUI
import YouTubePlayerKit

struct MovieTrailerView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        #if os(iOS)
        YouTubePlayerView(YouTubePlayer(urlString: "\(networkManager.videoUrl)" + "\(movie.movieTrailer)"))
            .frame(idealWidth: 300, idealHeight: 250)
            .cornerRadius(20)
            .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
        #else
        YouTubePlayerView(YouTubePlayer(urlString: "\(networkManager.videoUrl)" + "\(movie.movieTrailer)"))
            .frame(minWidth: 350, minHeight: 300)
            .cornerRadius(20)
            .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
        #endif
    }
}

#Preview {
    MovieTrailerView(movie: .example)
}
