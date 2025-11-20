//
//  DataManager-Create.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 13/11/2025.
//

import Foundation
import CoreData

extension DataManager {
    
    /// Creates a movie in the view context using fetched data
    /// - Parameters:
    ///   - content: The content fetched from the api
    ///   - castMembers: Cast members relative to the content fetched
    ///   - directors: Directors relative to the content fetched
    func createMovie(fromContent content: TmdbContent, priority: WatchPriority = .low, withCastMembers castMembers: [Cast], andDirectors directors: [Cast]) {
        let movie = Movie(context: container.viewContext)
        
        movie.poster = content.posterPath
        movie.title = content.title
        movie.overview = content.overview
        movie.budget = Int64(content.budget ?? 0)
        if let genres = content.genres {
            movie.genres = genres.map(\.self.name).joined(separator: ", ")
        }
        movie.id = Int64(content.id)
        movie.releaseDate = content.releaseDate
        movie.runTime = Int64(content.runtime ?? 0)
        if let videos = content.videos, let video = videos.results.first(where: {$0.type == "Trailer"}) {
            movie.trailerUrl = video.key
        }
        movie.voteAverage = content.voteAverage ?? 0
        movie.priority = priority.rawValue
        movie.watched = false
        
        var actors: [Actor] = []
        
        /// We need to add a rank to the actors so we can sort them in the good order
        castMembers.enumerated().forEach { i, castMember in
            let actor = Actor(context: container.viewContext)
            actor.rank = Int32(i)
            actor.id = Int64(castMember.id)
            actor.name = castMember.name
            actor.picture = castMember.profilePath
            actors.append(actor)
        }
        
        movie.actors = NSSet(array: actors)
        
        var directorsToSave: [Director] = []
        
        for director in directors {
            let directorObject = Director(context: container.viewContext)
            directorObject.id = Int64(director.id)
            directorObject.name = director.name
            directorObject.picture = director.profilePath
            directorsToSave.append(directorObject)
        }
        
        movie.directors = NSSet(array: directorsToSave)
        
        save()
    }
    
    /// Creates a Tv show  in the view context using fetched data
    /// - Parameters:
    ///   - content: The content fetched from the api
    ///   - castMembers: Cast members relative to the content fetched
    ///   - creators: Creators relative to the content fetched
    ///   - seasons: Seasons relative to the content fetched
    func createTvShow(fromContent content: TmdbContent, priority: WatchPriority = .low, withCastMembers castMembers: [Cast], creators: [Creator], andSeasons seasons: [Season]) {
        let show = TvShow(context: container.viewContext)
        
        show.poster = content.posterPath
        show.title = content.name
        show.overview = content.overview
        show.inProduction = content.inProduction ?? false
        if let genres = content.genres {
            show.genres = genres.map(\.self.name).joined(separator: ", ")
        }
        show.id = Int64(content.id)
        show.firstAirDate = content.firstAirDate
        show.lastAirDate = content.lastAirDate
        show.numberOfEpisodes = Int64(content.numberOfEpisodes ?? 0)
        show.numberOfSeasons = Int64(content.numberOfSeasons ?? 0)
        if let videos = content.videos, let video = videos.results.first(where: {$0.type == "Trailer"}) {
            show.trailerUrl = video.key
        }
        show.voteAverage = content.voteAverage ?? 0
        show.priority = priority.rawValue
        show.watched = false
        
        var directorsToSave: [Director] = []
        
        for creator in creators {
            let directorObject = Director(context: container.viewContext)
            directorObject.id = Int64(creator.id)
            directorObject.name = creator.name
            directorObject.picture = creator.profilePath
            directorsToSave.append(directorObject)
        }
        
        show.directors = NSSet(array: directorsToSave)
        
        var actors: [Actor] = []
        
        /// We need to add a rank to the actors so we can sort them in the good order
        castMembers.enumerated().forEach { i, castMember in
            let actor = Actor(context: container.viewContext)
            actor.rank = Int32(i)
            actor.id = Int64(castMember.id)
            actor.name = castMember.name
            actor.picture = castMember.profilePath
            actors.append(actor)
        }
        
        show.actors = NSSet(array: actors)
        
        var seasonsToSave: [ShowSeason] = []
        
        /// We give a rank to the seasons in case the season number is missing so it still appears in the right order
        seasons.enumerated().forEach { i, season in
            if season.name != "Specials" || season.airDate != nil {
                let showSeason = ShowSeason(context: container.viewContext)
                showSeason.rank = Int64(i)
                showSeason.id = Int64(season.id)
                showSeason.airDate = season.airDate
                showSeason.name = season.name
                showSeason.overview = season.overview
                showSeason.seasonNumber = Int64(season.seasonNumber ?? 0)
                showSeason.voteAverage = season.voteAverage ?? 0
                showSeason.poster = season.posterPath
                var seasonEpisodes: [ShowEpisode] = []
                season.episodes?.enumerated().forEach { i, episode in
                    let showEpisode = ShowEpisode(context: container.viewContext)
                    showEpisode.rank = Int64(i)
                    showEpisode.id = Int64(episode.id)
                    showEpisode.airDate = episode.airDate
                    showEpisode.episodeNumber = Int64(episode.episodeNumber ?? 0)
                    showEpisode.name = episode.name
                    showEpisode.overview = episode.overview
                    showEpisode.stillPath = episode.stillPath
                    showEpisode.voteAverage = episode.voteAverage ?? 0
                    showEpisode.runTime = Int64(episode.runtime ?? 0)
                    seasonEpisodes.append(showEpisode)
                }
                showSeason.episodes = NSSet(array: seasonEpisodes)
                
                seasonsToSave.append(showSeason)
            }
        }
        
        show.seasons = NSSet(array: seasonsToSave)
        
        save()
    }
}
