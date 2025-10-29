//
//  ExtensionTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 14/10/2025.
//

import XCTest
import CoreData
@testable import MyWatchList

final class ExtensionTests: MyWatchListBaseTestCase {
    //Movie helpers
    func testMovieHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Movie>(entityName: "Movie")
        let movies = try managedObjectContext.fetch(request)
        
        let movie = movies.sorted()[0]
        
        XCTAssertEqual(movie.movieTitle, "Avengers: Infinity War")
        XCTAssertEqual(movie.moviePoster, "/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg")
        XCTAssertEqual(movie.movieOverview, "As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable power, and use them to inflict his twisted will on all of reality. Everything the Avengers have fought for has led up to this moment - the fate of Earth and existence itself has never been more uncertain.")
        XCTAssertEqual(movie.movieBudget, 300000000)
        XCTAssertEqual(movie.movieGenres, "Adventure, Action, Science Fiction")
        XCTAssertEqual(movie.movieReleaseDate, "2018-04-25")
        XCTAssertEqual(movie.movieId, 86311)
        XCTAssertEqual(movie.movieVoteAverage, "8.2")
        XCTAssertEqual(movie.movieTrailer, "6ZfuNTqbHE8")
        XCTAssertEqual(movie.movieRuntime, 149)
        XCTAssertEqual(movie.movieImdbUrl, "test")
    }
    
    //TvShow helpers
    func testTvShowHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let tvShows = try managedObjectContext.fetch(request)
        
        let tvShow = tvShows[0]
        
        XCTAssertEqual(tvShow.showPoster, "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg")
        XCTAssertEqual(tvShow.showTitle, "Sons of Anarchy")
        XCTAssertEqual(tvShow.showOverview, "The Sons of Anarchy (SOA) are an outlaw motorcycle club with many charters in the United States and overseas. The show focused on the original and founding charter, Sons of Anarchy Motorcycle Club, Redwood Original, often referred to by the acronym SAMCRO, Sam Crow, or simply Redwood Charter. The charter operates both legal and illegal businesses in the small town of Charming, California. They combine gun-running and a garage, and involvement in porn film industry. Clay, the charter president, likes it old school and violent; while Jax, his stepson and the club's VP, has thoughts about changing the way things are done. Their conflict has effects on both the club and their personal relationship, especially when Jax goes on a personal quest to cleanse the SAMCRO name and image.")
        XCTAssertEqual(tvShow.showGenres, "Crime, Drama")
        XCTAssertEqual(tvShow.showId, 1409)
        XCTAssertEqual(tvShow.showFirstAirDate, "2008-09-03")
        XCTAssertEqual(tvShow.showLastAirDate, "2014-12-09")
        XCTAssertEqual(tvShow.showNumberOfEpisodes, 92)
        XCTAssertEqual(tvShow.showTrailer, "paBZJJXUEtg")
        XCTAssertEqual(tvShow.showVoteAverage, "8.4")
        XCTAssertEqual(tvShow.showDirectors.count, 1)
        XCTAssertEqual(tvShow.showInProduction, false)
        XCTAssertEqual(tvShow.showImdbUrl, "test")
        XCTAssertEqual(tvShow.allSeasonsWatched, false)
        XCTAssertEqual(tvShow.showProgress, 0.0)
    }
    
    //Actor helpers
    func testTvShowActorHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let tvShows = try managedObjectContext.fetch(request)
        
        let tvShow = tvShows[0]
        let actors = tvShow.showActors
        let actor = actors[0]
        
        XCTAssertEqual(actors.count, 1)
        XCTAssertEqual(actor.actorId, 1)
        XCTAssertEqual(actor.actorName, "Adam Test")
        XCTAssertEqual(actor.actorPicture, "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg")
    }
    
    func testMovieActorHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Movie>(entityName: "Movie")
        let movies = try managedObjectContext.fetch(request)
        
        let movie = movies.sorted()[0]
        let actors = movie.movieActors
        let actor = actors[0]
        
        XCTAssertEqual(actors.count, 1)
        XCTAssertEqual(actor.actorId, 1)
        XCTAssertEqual(actor.actorName, "Adam Test")
        XCTAssertEqual(actor.actorPicture, "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg")
    }
    
    
    //Season helpers
    func testSeasonHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let tvShows = try managedObjectContext.fetch(request)
        
        let tvShow = tvShows[0]
        let season = tvShow.showSeasons[0]
        
        XCTAssertEqual(season.seasonId, 3684)
        XCTAssertEqual(season.seasonAirDate, "2008-09-03")
        XCTAssertEqual(season.seasonName, "Season 1")
        XCTAssertEqual(season.seasonOverview, "The Sons of Anarchy live, ride, and die for brotherhood. But as the club's leader Clay Morrow and his wife Gemma steer them in an increasingly lawless direction, Gemma's son Jax is torn between loyalty and the legacy.")
        XCTAssertEqual(season.allEpisodesWatched, false)
        XCTAssertEqual(season.watched, false)
        XCTAssertEqual(season.seasonProgress, 0)
        XCTAssertEqual(season.seasonSeasNumber, 1)
        XCTAssertEqual(season.seasonVoteAverage, "8.1")
        XCTAssertEqual(season.seasonPoster, "/eZJPW8G7o0b2fH7GC7Av4MOKTj3.jpg")
        XCTAssertEqual(season.seasonEpisodeCount, 1)
    }
    
    //Episode helpers
    func testEpisodeHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let tvShows = try managedObjectContext.fetch(request)
        
        let tvShow = tvShows[0]
        let season = tvShow.showSeasons[0]
        let episode = season.seasonEpisodes[0]
        
        XCTAssertEqual(episode.episodeName, "Pilot")
        XCTAssertEqual(episode.episodeOverview, "When a rival club cleans out and then destroys their illegal arms warehouse, SAMCRO (Sons of Anarchy Motorcycle Club, Redwood Original) executes their own sense of justice in retrieving their guns. Meanwhile, family issues take center stage with a medical emergency involving Jax Teller's newborn son.")
        XCTAssertEqual(episode.episodeStillPath, "/jc2RFJIJBFqsMpxnCD6VParg8Rj.jpg")
        XCTAssertEqual(episode.episodeRunTime, 57)
        XCTAssertEqual(episode.episodeVoteAverage, "8.4")
        XCTAssertEqual(episode.episodeAirDate, "2008-09-03")
    }
    
    //Director helpers
    func testTvShowDirectorHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let tvShows = try managedObjectContext.fetch(request)
        
        let tvShow = tvShows[0]
        let creator = tvShow.showDirectors[0]
        
        XCTAssertEqual(creator.directorName, "Kurt Sutter")
        XCTAssertEqual(creator.directorId, 200043)
        XCTAssertEqual(creator.directorPicture, "/A4c9xpj2VuZXGvSv6z1S912Xwnd.jpg")
    }
    
    func testMovieDirectorHelpersUnwrapCorrectly() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Movie>(entityName: "Movie")
        let movies = try managedObjectContext.fetch(request)
        
        let movie = movies.sorted()[0]
        let directors = movie.movieDirectors
        
        XCTAssertEqual(directors.count, 2)
        XCTAssertEqual(directors[0].directorId, 19271)
        XCTAssertEqual(directors[0].directorPicture, "/xbINBnWn28YygYWUJ1aSAw0xPRv.jpg")
        XCTAssertEqual(directors[0].directorName, "Anthony Russo")
    }
    
    func testMovieHelpersUnwrapCorrectlyWhenAddingTag() throws {
        let tag = Tag(context: managedObjectContext)
        let movie = Movie(context: managedObjectContext)
        
        tag.name = "test"
        movie.addToTags(tag)
        
        XCTAssertEqual(movie.movieTagsList, "test")
        XCTAssertEqual(movie.movieTags.count, 1)
    }
    
    func testTvShowHelpersUnwrapCorrectlyWhenAddingTag() throws {
        let tag = Tag(context: managedObjectContext)
        let show = TvShow(context: managedObjectContext)
        
        tag.name = "test"
        show.addToTags(tag)
        
        XCTAssertEqual(show.showTagsList, "test")
        XCTAssertEqual(show.showTags.count, 1)
    }
    
    func testTagBasicHelpersUnwrapCorrectly() {
        let tag = Tag(context: managedObjectContext)
        
        tag.id = UUID()
        tag.name = "test"
        
        XCTAssertEqual(tag.tagID, tag.id)
        XCTAssertEqual(tag.tagName, "test")
    }
    
    func testTagHelpersUnwrapCorrectlyWhenAttachedToAMovie() {
        let tag = Tag(context: managedObjectContext)
        let movie = Movie(context: managedObjectContext)
        
        XCTAssertEqual(tag.tagMovies.count, 0)
        
        tag.addToMovies(movie)
        
        XCTAssertEqual(tag.tagMovies.count, 1)
    }
    
    func testTagHelpersUnwrapCorrectlyWhenAttachedToATvShow() {
        let tag = Tag(context: managedObjectContext)
        let show = TvShow(context: managedObjectContext)
        
        XCTAssertEqual(tag.tagTvShows.count, 0)
        
        tag.addToShows(show)
        
        XCTAssertEqual(tag.tagTvShows.count, 1)
    }
}
