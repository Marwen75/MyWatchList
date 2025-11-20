//
//  WatchableItem.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import Foundation

/// A protocol that unifies shared display and data properties between Movie and TvShow.
/// It inherits from `NotifiableItem` to include reminder support,
/// and from `ObservableObject` to support SwiftUI data binding.
protocol WatchableItem: NotifiableItem, ObservableObject {
    var itemID: Int { get }
    var itemTitle: String { get }
    var itemPosterPath: String { get }
    var trailerPath: String { get }
    var itemActors: [Actor] { get }
    var itemCredits: [Director] { get }
    var crewLabelSingular: String { get }
    var crewLabelPlural: String { get }
    var itemGenres: String { get }
    var itemOverview: String { get }
    var itemRating: String { get }
    var itemPriority: Int16 { get }
    var itemTagsList: String { get }
    var itemWatched: Bool { get }
}

extension WatchableItem {
    var cacheIdentifier: String {
        let typeName = String(describing: Self.self)
        return "\(typeName)_\(itemID)"
    }
}
