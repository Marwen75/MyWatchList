//
//  DataManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import CoreData

class DataManager: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedFilter: Filter? = Filter.all
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Fatal error while loading persistent stores: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method to save the view context only if changes were made
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    /// Method to delete an object from the view context
    /// - Parameter object: The object to be deleted
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
}
