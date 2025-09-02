//
//  Content-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

extension Content {
    var contentId: String {
        id ?? ""
    }
    
    var contentTitle: String {
        title ?? ""
    }
    
    var contentActors: String {
        actors ?? ""
    }
    
    var contentAka: String {
        aka ?? ""
    }
    
    var contentYear: Int {
        Int(year)
    }
    
    var contentImdbUrl: String {
        imdbUrl ?? ""
    }
    
    var contentPosterUrl: String {
        imgPoster ?? ""
    }
    
    /// Needed to get rid of the core data NSSet and get an array of tags instead
    var contentTags: [Tag] {
        let arrayOfTags = tags?.allObjects as? [Tag] ?? []
        return arrayOfTags.sorted()
    }
}

extension Content: Comparable {
    public static func < (lhs: Content, rhs: Content) -> Bool {
        lhs.contentTitle.lowercased() < rhs.contentTitle.lowercased()
    }
}
