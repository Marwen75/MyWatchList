//
//  Movie-Preview.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 21/10/2025.
//

import Foundation
import CoreData

#if DEBUG
extension Movie {
    static var example: Movie {
        let manager = DataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        
        let movie = Movie(context: viewContext)
        movie.poster = "/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg"
        movie.title = "Avengers: Infinity War"
        movie.overview = "As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable power, and use them to inflict his twisted will on all of reality. Everything the Avengers have fought for has led up to this moment - the fate of Earth and existence itself has never been more uncertain."
        movie.budget = Int64(300000000)
        movie.genres = "Adventure, Action, Science Fiction"
        movie.id = Int64(86311)
        movie.releaseDate = "2018-04-25"
        movie.runTime = Int64(149)
        movie.trailerUrl = "6ZfuNTqbHE8"
        movie.voteAverage = 8.235
        
        let director = Director(context: viewContext)
        director.name = "Anthony Russo"
        director.id = Int64(19271)
        director.picture = "/xbINBnWn28YygYWUJ1aSAw0xPRv.jpg"
        
        let director2 = Director(context: viewContext)
        director2.name = "Joe Russo"
        director2.id = Int64(19272)
        director2.picture = "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg"
        movie.directors = NSSet(array: [director, director2])
        
        return movie
    }
}
#endif
