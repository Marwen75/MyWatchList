//
//  Filter.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var typeOfContent: TypeOfContent
    var tag: Tag?
    
    static var movies = Filter(id: UUID(), name: NSLocalizedString("Movies", comment: "All movies"), icon: "film", typeOfContent: .movies)
    static var tvShows = Filter(id: UUID(), name: NSLocalizedString("Tv Shows", comment: "All shows"), icon: "tv", typeOfContent: .shows)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}

enum TypeOfContent: String, CaseIterable {
    case movies = "Movies"
    case shows = "Tv Shows"
}
