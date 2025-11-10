//
//  SearchRoute.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 02/10/2025.
//

import Foundation

enum SearchRoute: Hashable {
    case searchDetails(tmdbId: Int)
    case seasonDetails(season: Season)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: SearchRoute, rhs: SearchRoute) -> Bool {
        switch (lhs, rhs) {
        case (.searchDetails(let lhsId), .searchDetails(let rhsId)):
            return lhsId == rhsId
        case (.seasonDetails(let lhsSeason), .seasonDetails(let rhsSeason)):
            return lhsSeason.id == rhsSeason.id
        default:
            return false
        }
    }
}
