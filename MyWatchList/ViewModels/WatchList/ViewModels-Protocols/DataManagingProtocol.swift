//
//  DataManagingProtocol.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 22/10/2025.
//

import Foundation
import CoreData

/// I use protcols here in case I need specific view models for the mac version in the future, a side bar view model
/// for example and a content view view model. Since they don't need all the info of the watch list view model
/// the will conform to the protocols they need.

@MainActor
protocol DataManagingProtocol: AnyObject {
    var dataManager: DataManager { get }
    
    func delete<T: NSManagedObject>(_ objects: [T], atOffsets offsets: IndexSet)
}

extension DataManagingProtocol {
    func delete<T: NSManagedObject>(_ objects: [T], atOffsets offsets: IndexSet) {
        for offset in offsets {
            dataManager.delete(objects[offset])
        }
    }
    
    func deleteMovie(atOffsets offsets: IndexSet) {
        delete(dataManager.fetchMovies(), atOffsets: offsets)
    }
    
    func deleteTvShow(atOffsets offsets: IndexSet) {
        delete(dataManager.fetchTvShows(), atOffsets: offsets)
    }
}
