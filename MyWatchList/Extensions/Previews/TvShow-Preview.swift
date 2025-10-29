//
//  TvShow-Preview.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 21/10/2025.
//

import Foundation

#if DEBUG
extension TvShow {
    static var example: TvShow {
        let manager = DataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        
        let show = TvShow(context: viewContext)
        show.poster = "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg"
        show.title = "Sons of anarchy"
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
        
        show.seasons = NSSet(array: [season1])
        
        show.directors = NSSet(array: [creator])
        
        return show
    }
}
#endif
