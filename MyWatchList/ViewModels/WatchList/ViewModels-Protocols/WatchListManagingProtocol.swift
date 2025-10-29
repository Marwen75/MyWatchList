//
//  WatchListManagingProtocol.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 22/10/2025.
//

import Foundation
import CoreData

typealias WatchListManagingProtocol = TagManagingProtocol & TagRenamingProtocol

/// We use protcols here in case I need specifics view models for the mac version in the future, a side bar view model
/// for example and a content view view model. Since they don't need all the info of the watch list view model
/// the will conform to the protocols they need.

@MainActor
protocol TagManagingProtocol: DataManagingProtocol {
    var tags: [Tag] { get set }
    var movieTags: [Filter] { get set }
    var showTags: [Filter] { get set }
    
    func deleteMovieTag(_ offsets: IndexSet)
    func deleteShowTag(_ offsets: IndexSet)
    func getCustomTags(forMovies: Bool) -> [Filter]
}

extension TagManagingProtocol {
    func deleteTagFilters(_ filters: [Filter], atOffsets offsets: IndexSet) {
        for offset in offsets {
            if let tag = filters[offset].tag {
                dataManager.delete(tag)
            }
        }
    }
    
    func getCustomTags(forMovies: Bool) -> [Filter] {
        let allTags = tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", typeOfContent: tag.isMovieTag == true ? .movies : .shows, tag: tag)
        }
        
        return allTags.filter { filter in
            forMovies ? filter.typeOfContent == .movies : filter.typeOfContent == .shows
        }
    }
}

@MainActor
protocol TagRenamingProtocol: DataManagingProtocol {
    var tagToRename: Tag? { get set }
    var renamingTag: Bool { get set }
    var tagName: String { get set }
    
    func rename(_ filter: Filter)
    func completeRename()
}

extension TagRenamingProtocol {
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    func completeRename() {
        tagToRename?.name = tagName
        dataManager.save()
    }
}
