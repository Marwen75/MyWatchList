//
//  Movie-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

extension Movie {
    var movieId: Int {
        Int(id)
    }
    
    var movieTitle: String {
        title ?? ""
    }
    
    var movieBudget: Int {
        Int(budget)
    }
    
    var movieOverview: String {
        overview ?? ""
    }
    
    var movieImdbUrl: String {
        imdbUrl ?? ""
    }
    
    var movieReleaseDate: String {
        releaseDate ?? ""
    }
    
    var moviePoster: String {
        poster ?? ""
    }
    
    var movieTrailer: String {
        trailerUrl ?? ""
    }
    
    var movieVoteAverage: String {
        String(format: "%.1f", voteAverage)
    }
    
    var movieRuntime: Int {
        Int(runTime)
    }
    
    var movieGenres: String {
        genres ?? "N/A"
    }
    
    /// Needed to get rid of the core data NSSet and get an array of tags instead
    var movieTags: [Tag] {
        let arrayOfTags = tags?.allObjects as? [Tag] ?? []
        return arrayOfTags.sorted()
    }
    
    /// Return a list of tag names to display 
    var movieTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return movieTags.map(\.tagName).formatted()
        }
    }
    
    var movieDirectors: [Director] {
        let arrayOfDirectors = directors?.allObjects as? [Director] ?? []
        return arrayOfDirectors.sorted { $0.directorName < $1.directorName }
    }
    
    var movieActors: [Actor] {
        let arrayOfActors = actors?.allObjects as? [Actor] ?? []
        return arrayOfActors.sorted { ac, act in
            ac.rank < act.rank
        }
    }
}

extension Movie: Comparable {
    public static func < (lhs: Movie, rhs: Movie) -> Bool {
        lhs.movieTitle.lowercased() < rhs.movieTitle.lowercased()
    }
}
