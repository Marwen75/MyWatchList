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
    var typeOfContent: String?
    var tag: Tag?
    
    static var all = Filter(id: UUID(), name: "All contents", icon: "tray")
    static var movie = Filter(id: UUID(), name: "Movies", icon: "film", typeOfContent: "MOVIE")
    static var show = Filter(id: UUID(), name: "Shows", icon: "tv", typeOfContent: "SHOW")
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
