//
//  WatchListViewModel.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 16/10/2025.
//

import Foundation
import CoreData

@dynamicMemberLookup
class WatchListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate, WatchListManagingProtocol {
    var dataManager: DataManager
    private let tagsController: NSFetchedResultsController<Tag>
    
    @Published var tagToRename: Tag?
    @Published var renamingTag = false
    @Published var tagName = ""
    @Published var showTagAlert = false
    @Published var presentFilterSheet = false
    @Published var showFetchAlert = false
    @Published var errorMessage = ""
    @Published var tags: [Tag] = []
    @Published var movieTags: [Filter] = []
    @Published var showTags: [Filter] = []
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        let request = Tag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]
        
        tagsController = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: dataManager.container.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        tagsController.delegate = self
        
        do {
            try tagsController.performFetch()
            tags = tagsController.fetchedObjects ?? []
        } catch {
            errorMessage = error.localizedDescription
            showFetchAlert = true
        } 
        
        movieTags = getCustomTags(forMovies: true)
        showTags = getCustomTags(forMovies: false)
    }
    
    
    func deleteMovieTag(_ offsets: IndexSet) {
        deleteTagFilters(movieTags, atOffsets: offsets)
    }
    
    func deleteShowTag(_ offsets: IndexSet) {
        deleteTagFilters(showTags, atOffsets: offsets)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newTags = controller.fetchedObjects as? [Tag] {
            tags = newTags
            movieTags = getCustomTags(forMovies: true)
            showTags = getCustomTags(forMovies: false)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<DataManager, Value>) -> Value? {
        dataManager[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataManager, Value>) -> Value {
        get { dataManager[keyPath: keyPath] }
        set { dataManager[keyPath: keyPath] = newValue }
    }
}
