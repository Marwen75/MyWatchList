//
//  MovieMainInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 24/09/2025.
//

import SwiftUI

struct MovieMainInfoView: View {
    @ObservedObject var movie: Movie
    
    var body: some View {
        #if os(iOS)
        VStack(alignment: .leading) {
            Label(movie.movieDirectors.count > 1 ? "Directors" : "Director", systemImage: "person.crop.square.badge.video")
            
            MovieDirectorView(movie: movie)
        }
        .infoStyle()
        
        HStack {
            Label("\(movie.movieReleaseDate)", systemImage: "calendar")
            
            Spacer()
            
            Label(movie.movieBudget == 0 ? "N/A" : "\(movie.movieBudget)", systemImage: "dollarsign.circle")
        }
        .infoStyle()
        
        HStack {
            Label("\(movie.movieRuntime, default: "N/A") minutes", systemImage: "clock")
            
            Spacer()
            
            Label(movie.movieVoteAverage == "0" ? "N/A" : movie.movieVoteAverage + "/10", systemImage: "star.circle")
        }
        .infoStyle()
        
        
        Text(movie.movieGenres)
            .infoStyle()
        
        
        Text(movie.movieOverview)
            .overviewStyle()
        #else
            VStack(alignment: .leading) {
                CustomDivider()
                
                Label(movie.movieDirectors.count > 1 ? "Directors" : "Director", systemImage: "person.crop.square.badge.video")
                    .infoStyle()
                
                MovieDirectorView(movie: movie)
                
                VStack(spacing: 10) {
                    CustomDivider()
                    
                    HStack {
                        Label("\(movie.movieReleaseDate)", systemImage: "calendar")
                        
                        Spacer()
                        
                        Label(movie.movieBudget == 0 ? "N/A" : "\(movie.movieBudget)", systemImage: "dollarsign.circle")
                    }
                    
                    CustomDivider()
                    
                    HStack {
                        Label("\(movie.movieRuntime, default: "N/A") minutes", systemImage: "clock")
                        
                        Spacer()
                        
                        Label(movie.movieVoteAverage == "0" ? "N/A" : movie.movieVoteAverage + "/10", systemImage: "star.circle")
                    }
                    
                    CustomDivider()
                    
                    Text(movie.movieGenres)
                    
                    CustomDivider()
                    
                    Text(movie.movieOverview)
                    
                    CustomDivider()
                }
                .infoStyle()
                
                Spacer()
                
                MoviePriorityAndTagView(movie: movie)
            }
        #endif
    }
}

#Preview {
    MovieMainInfoView(movie: .example)
        .environmentObject(DataManager.preview)
}
