//
//  MovieListRowPosterWithInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 17/10/2025.
//

import SwiftUI

struct MovieListRowPosterWithInfoView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        ZStack(alignment: .top) {
            ListRowPosterImageView(minHeight: 150, maxHeight: 700, path: movie.moviePoster)
            
            VStack {
                HStack {
                    Label(movie.movieTagsList, systemImage: "tag")
                        .padding(10)
                        .background(Color.red.mix(with: .black, by: 0.6).opacity(0.8))
                        .cornerRadius(20)
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    switch movie.priority {
                    case 0:
                        Label(movie.watched ? "Re-watch eventually" : "Watch later", systemImage: "eye.half.closed")
                            .padding(10)
                            .background(Color.red.mix(with: .black, by: 0.6).opacity(0.8))
                            .cornerRadius(20)
                    case 1:
                        Label(movie.watched ? "Re-watch soon" : "Must see", systemImage: "eye")
                            .padding(10)
                            .background(Color.red.mix(with: .black, by: 0.6).opacity(0.8))
                            .cornerRadius(20)
                    default:
                        Label(movie.watched ? "Re-watch urgently" : "See urgently", systemImage: "eye.trianglebadge.exclamationmark")
                            .padding(10)
                            .background(Color.red.mix(with: .black, by: 0.6).opacity(0.8))
                            .cornerRadius(20)
                    }
                    Spacer()
                }
            }
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(.primary)
            .fontWidth(.condensed)
            .padding(5)
        }
    }
}

#Preview {
    MovieListRowPosterWithInfoView(movie: .example)
}
