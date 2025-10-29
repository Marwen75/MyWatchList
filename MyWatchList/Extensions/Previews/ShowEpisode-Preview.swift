//
//  ShowEpisode-Preview.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 21/10/2025.
//

import Foundation

#if DEBUG
extension ShowEpisode {
    static var exampleEpisode: ShowEpisode {
        let manager = DataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        let episode1 = ShowEpisode(context: viewContext)
        episode1.airDate = "2008-09-03"
        episode1.id = 63924
        episode1.name = "Pilot"
        episode1.overview = "When a rival club cleans out and then destroys their illegal arms warehouse, SAMCRO (Sons of Anarchy Motorcycle Club, Redwood Original) executes their own sense of justice in retrieving their guns. Meanwhile, family issues take center stage with a medical emergency involving Jax Teller's newborn son."
        episode1.episodeNumber = Int64(1)
        episode1.runTime = 57
        episode1.voteAverage = 8.4
        episode1.stillPath = "/jc2RFJIJBFqsMpxnCD6VParg8Rj.jpg"
        
        return episode1
    }
}
#endif
