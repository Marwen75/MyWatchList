//
//  ShowEpisode-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import Foundation

extension ShowEpisode {
    var episodeName: String {
        name ?? "N/A"
    }
    
    var episodeOverview: String {
        overview ?? "N/A"
    }
    
    var episodeStillPath: String {
        stillPath ?? ""
    }
    
    var episodeRunTime: Int {
        Int(runTime)
    }
    
    var episodeAirDate: String {
        airDate ?? "N/A"
    }
    
    var episodeVoteAverage: String {
        String(format: "%.1f", voteAverage)
    }
    
    var seasonNum: Int {
        Int(season?.seasonSeasNumber ?? 0)
    }
    
    var episodeNum: Int {
        Int(episodeNumber)
    }
    
    var formattedNextEp: String {
        "S\(seasonNum)E\(episodeNum)"
    }
}
