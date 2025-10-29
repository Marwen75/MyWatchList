//
//  MovieDirectorView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 24/09/2025.
//

import SwiftUI

struct MovieDirectorView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(movie.movieDirectors) { director in
                    if director.directorPicture != "" {
                        PersonImageView(width: 50, height: 50, profilePath: director.directorPicture)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().stroke(Color.yellow.mix(with: .black, by: 0.3), lineWidth: 1)
                            }
                            .shadow(color: .aluminum, radius: 3)
                    }
                    
                    Text(director.name ?? "")
                        .infoStyle()
                    
                    Spacer()
                }
            }
        }
        .scrollDisabled(movie.movieDirectors.count <= 1)
        .safeAreaPadding([.leading, .top, .bottom], 10)
    }
}

#Preview {
    MovieDirectorView(movie: .example)
}
