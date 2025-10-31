//
//  DetailMovieView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//
#if os(macOS)
import SwiftUI


struct DetailMovieView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var movie: Movie
    @State private var shouldRefresh = false
    
    var body: some View {
        ScrollView {
            HStack {
                PosterImageView(path: movie.moviePoster, size: .flexible(maxWidth: 350, maxHeight: 500))
                    .onChange(of: movie) {
                        shouldRefresh.toggle()
                    }
                
                MovieMainInfoView(movie: movie)
            }
            .padding()
            
            CustomDivider()
                .padding()
            
            MovieTrailerView(movie: movie)
                    .padding()
                    .id(shouldRefresh)
            
            CustomDivider()
                .padding()
            
            MovieCastView(movie: movie)
                .padding()
            
            CustomDivider()
                .padding()
            
            Button {
                movie.watched.toggle()
            } label: {
                Text(movie.watched ? "Mark as unwatched" : "Mark as watched")
            }
            .frame(width: 200, height: 150)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(movie.watched ? Color.darkGreen : Color.darkYellow)
        }
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    DetailMovieView(movie: .example)
        .environmentObject(DataManager.preview)
}
#endif
