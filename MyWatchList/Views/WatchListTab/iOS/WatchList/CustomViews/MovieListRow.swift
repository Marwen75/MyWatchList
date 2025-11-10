//
//  MovieListRow.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

import SwiftUI

struct MovieListRow: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        NavigationLink(value: WatchListRoute.movieDetails(movie: movie)) {
            VStack {
                Text(movie.movieTitle)
                    .contentTitleStyle()
                
                Spacer()
                
                ItemListRowPosterWithInfoView(item: movie)
            }
        } 
    }
}

#Preview {
    MovieListRow(movie: .example)
}
