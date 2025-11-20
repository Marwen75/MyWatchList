//
//  DataManager-Preview.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 13/11/2025.
//

#if DEBUG
import Foundation
import CoreData

extension DataManager {
    /// For preview purposes only
    static var preview: DataManager = {
        let dataManager = DataManager(inMemory: true)
        dataManager.createSampleData()
        return dataManager
    }()

    func createSampleData() {
        container.viewContext.performAndWait {
            let viewContext = container.viewContext
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
            movie.imdbUrl = "test"
            movie.priority = 2
            movie.watched = false
            
            let director = Director(context: viewContext)
            director.name = "Anthony Russo"
            director.id = Int64(19271)
            director.picture = "/xbINBnWn28YygYWUJ1aSAw0xPRv.jpg"
            
            let director2 = Director(context: viewContext)
            director2.name = "Joe Russo"
            director2.id = Int64(19272)
            director2.picture = "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg"
            movie.directors = NSSet(array: [director, director2])
            
            let actor = Actor(context: viewContext)
            actor.name = "Adam Test"
            actor.id = 1
            actor.picture = "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg"
            
            movie.actors = NSSet(array: [actor])
            
            let movie2 = Movie(context: viewContext)
            movie2.poster = "/lV5OpzAss1z06YNagOVap1I35mH.jpg"
            movie2.title = "Star Trek"
            movie2.overview = "The fate of the galaxy rests in the hands of bitter rivals. One, James Kirk, is a delinquent, thrill-seeking Iowa farm boy. The other, Spock, a Vulcan, was raised in a logic-based society that rejects all emotion. As fiery instinct clashes with calm reason, their unlikely but powerful partnership is the only thing capable of leading their crew through unimaginable danger, boldly going where no one has gone before. The human adventure has begun again."
            movie2.budget = Int64(150000000)
            movie2.genres = "Adventure, Action, Science Fiction"
            movie2.id = Int64(115575)
            movie2.releaseDate = "2009-05-06"
            movie2.runTime = Int64(127)
            movie2.trailerUrl = "pFVvigZ5wQY"
            movie2.voteAverage = 7.425
            movie2.priority = 0
            movie2.watched = false
            
            let show = TvShow(context: viewContext)
            show.poster = "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg"
            show.title = "Sons of Anarchy"
            show.overview = "The Sons of Anarchy (SOA) are an outlaw motorcycle club with many charters in the United States and overseas. The show focused on the original and founding charter, Sons of Anarchy Motorcycle Club, Redwood Original, often referred to by the acronym SAMCRO, Sam Crow, or simply Redwood Charter. The charter operates both legal and illegal businesses in the small town of Charming, California. They combine gun-running and a garage, and involvement in porn film industry. Clay, the charter president, likes it old school and violent; while Jax, his stepson and the club's VP, has thoughts about changing the way things are done. Their conflict has effects on both the club and their personal relationship, especially when Jax goes on a personal quest to cleanse the SAMCRO name and image."
            show.inProduction = false
            show.genres = "Crime, Drama"
            show.id = Int64(1409)
            show.firstAirDate = "2008-09-03"
            show.lastAirDate = "2014-12-09"
            show.numberOfEpisodes = Int64(92)
            show.numberOfSeasons = Int64(7)
            show.trailerUrl = "paBZJJXUEtg"
            show.voteAverage = 8.419
            show.inProduction = false
            show.imdbUrl = "test"
            let creator = Director(context: viewContext)
            creator.name = "Kurt Sutter"
            creator.id = Int64(200043)
            creator.picture = "/A4c9xpj2VuZXGvSv6z1S912Xwnd.jpg"
            
            let season1 = ShowSeason(context: viewContext)
            season1.id = Int64(3684)
            season1.airDate = "2008-09-03"
            season1.name = "Season 1"
            season1.overview = "The Sons of Anarchy live, ride, and die for brotherhood. But as the club's leader Clay Morrow and his wife Gemma steer them in an increasingly lawless direction, Gemma's son Jax is torn between loyalty and the legacy."
            season1.seasonNumber = Int64(1)
            season1.voteAverage = 8.1
            season1.poster = "/eZJPW8G7o0b2fH7GC7Av4MOKTj3.jpg"
            season1.watched = false
            
            let episode1 = ShowEpisode(context: viewContext)
            episode1.airDate = "2008-09-03"
            episode1.id = 63924
            episode1.name = "Pilot"
            episode1.overview = "When a rival club cleans out and then destroys their illegal arms warehouse, SAMCRO (Sons of Anarchy Motorcycle Club, Redwood Original) executes their own sense of justice in retrieving their guns. Meanwhile, family issues take center stage with a medical emergency involving Jax Teller's newborn son."
            episode1.episodeNumber = Int64(1)
            episode1.runTime = 57
            episode1.voteAverage = 8.4
            episode1.stillPath = "/jc2RFJIJBFqsMpxnCD6VParg8Rj.jpg"
            episode1.watched = false
            
            season1.episodes = NSSet(array: [episode1])
            
            
            show.seasons = NSSet(array: [season1])
            
            show.directors = NSSet(array: [creator])
            
            show.actors = NSSet(array: [actor])
            
            for i in 0...5 {
                let tag = Tag(context: viewContext)
                tag.id = UUID()
                tag.name = String(i)
                tag.isMovieTag = true
                tag.movies = NSSet(array: [movie])
            }
            
            for i in 0...5 {
                let tag = Tag(context: viewContext)
                tag.id = UUID()
                tag.name = "Tag number \(i)"
                tag.isMovieTag = false
                tag.shows = NSSet(array: [show])
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save sample data: \(error.localizedDescription)")
            }
        }
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // IMPORTANT: When performing a batch delete we need to make sure we read the result back
        // then merge all the changes from that result back into our live view context
        // so that the two stay in sync.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        delete(request2)
        
        let request3: NSFetchRequest<NSFetchRequestResult> = TvShow.fetchRequest()
        delete(request3)
        
        save()
    }
}
#endif
