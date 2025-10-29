//
//  Season-Preview.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 21/10/2025.
//

import Foundation

#if DEBUG
extension ShowSeason {
    static var example: ShowSeason {
        let manager = DataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        
        let season1 = ShowSeason(context: viewContext)
        season1.id = Int64(3684)
        season1.airDate = "2008-09-03"
        season1.name = "Season 1"
        season1.overview = "The Sons of Anarchy live, ride, and die for brotherhood. But as the club's leader Clay Morrow and his wife Gemma steer them in an increasingly lawless direction, Gemma's son Jax is torn between loyalty and the legacy."
        season1.seasonNumber = Int64(1)
        season1.voteAverage = 8.1
        season1.poster = "/eZJPW8G7o0b2fH7GC7Av4MOKTj3.jpg"
        
        let episode1 = ShowEpisode(context: viewContext)
        episode1.airDate = "2008-09-03"
        episode1.id = 63924
        episode1.name = "Pilot"
        episode1.overview = "When a rival club cleans out and then destroys their illegal arms warehouse, SAMCRO (Sons of Anarchy Motorcycle Club, Redwood Original) executes their own sense of justice in retrieving their guns. Meanwhile, family issues take center stage with a medical emergency involving Jax Teller's newborn son."
        episode1.episodeNumber = Int64(1)
        episode1.runTime = 57
        episode1.voteAverage = 8.4
        episode1.stillPath = "/jc2RFJIJBFqsMpxnCD6VParg8Rj.jpg"
        
        season1.episodes = NSSet(array: [episode1])
        
        return season1
    }
}
#endif
