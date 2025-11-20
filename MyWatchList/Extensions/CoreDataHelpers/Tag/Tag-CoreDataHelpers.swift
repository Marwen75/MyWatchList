//
//  Tag-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }
    
    var tagName: String {
        name ?? ""
    }
    
    var tagMovies: [Movie] {
        let arrayOfMovies = movies?.allObjects as? [Movie] ?? []
        return arrayOfMovies.sorted { $0.priority > $1.priority }
    }
    
    var tagTvShows: [TvShow] {
        let arrayOfShows = shows?.allObjects as? [TvShow] ?? []
        return arrayOfShows.sorted { $0.priority > $1.priority }
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.lowercased()
        let right = rhs.tagName.lowercased()
        
        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
