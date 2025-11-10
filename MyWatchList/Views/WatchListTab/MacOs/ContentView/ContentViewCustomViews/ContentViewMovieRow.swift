//
//  ContentViewMovieRow.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//

#if os(macOS)
import SwiftUI

struct ContentViewMovieRow: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.movieTitle)
            Label(movie.movieTagsList, systemImage: "tag")
            
            HStack {
                Spacer()
                PosterImageView(path: movie.moviePoster, size: .flexible(maxWidth: 150, maxHeight: 200))
                Spacer()
            }
            
            HStack {
                switch movie.priority {
                case 0:
                    Label("Watch later", systemImage: "eye.half.closed")
                        .imageScale(.small)
                case 1:
                    Label("Must watch", systemImage: "eye")
                        .imageScale(.small)
                default:
                    Label("Watch urgently", systemImage: "eye.trianglebadge.exclamationmark")
                        .imageScale(.small)
                }
            }
        }
        .padding(3)
        .infoStyle()
    }
}

#Preview {
    ContentViewMovieRow(movie: .example)
}
#endif
