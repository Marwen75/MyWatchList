//
//  DataManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import CoreData
import StoreKit
import Combine
import WidgetKit

class DataManager: ObservableObject {
    let container: NSPersistentCloudKitContainer
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?
    
    @Published var selectedFilter: Filter? = Filter.movies
    @Published var selectedMovie: Movie?
    @Published var selectedShow: TvShow?
    @Published var selectedSeason: ShowSeason?
    @Published var searchText = ""
    @Published var filterEnabled = false
    @Published var filterPriority = -1
    @Published var filterStatus = WatchStatus.all
    @Published var sortOrder = SortOrder.priority
    @Published var products: [Product] = []
    
    private var storeTask: Task<Void, Never>?
    
    let defaults: UserDefaults

    /// We need to explicitly create the model and inject it to the container to avoid multiple model instances loading when testing
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        
        return managedObjectModel
    }()
    
    /// Initializes a data manager either in memory or on permanent storage
    /// - Parameters:
    ///   - inMemory: Whether to store this data in temporary memory or not.
    ///   - defaults: The UserDefaults where user data should be stored.
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        // Injection of the previously created model, this way we don't need to use a mock for testing
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        // Watch for transactions as soon as possible and for as long as the app is running
        storeTask = Task { await monitorTransactions() }
        
        // For testing purposes
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        } else {
            let groupID = "group.com.marwen.MyWatchList"
            
            // Directing CoreData to share information with the AppGroup
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appending(path: "Main.sqlite")
            }
        }
        
        // Apply any changes that happen to the persisent store to our view context
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // Be notified when the store has changed
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator,
                                               queue: .main,
                                               using: remoteStoreChanged)
        
        
        container.loadPersistentStores { [weak self] _, error in
            if let error {
                fatalError("Fatal error while loading persistent stores: \(error.localizedDescription)")
            }
            
            // Initializing the spotlight delegate so the user can
            // search for a Movie or a Tv Show from his home screen
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(forStoreWith: description, coordinator: coordinator)
                }
                
                self?.spotlightDelegate?.startSpotlightIndexing()
            }
        }
    }
    
    /// Retrieves the count for a given fetch request.
    /// - Parameter fetchRequest: The fetch request to get the count for.
    /// - Returns: The count of the given fetch request
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    /// Saves the view context only if changes were made
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            
            //Force all widgets to update when a change occurs
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    /// Deletes an object from the view context
    /// - Parameter object: The object to be deleted
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    /// Deletes a movie from the view context using his id
    /// - Parameter id: The id of the movie to delete
    func deleteMovieWithId(_ id: Int64) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", id)
        if let movie = try? container.viewContext.fetch(request).first {
            delete(movie)
        }
    }
    
    /// Deletes a tv show from the view context using his id
    /// - Parameter id: The id of the tv show to delete
    func deleteShowWithId(_ id: Int64) {
        let request: NSFetchRequest<TvShow> = TvShow.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", id)
        if let tvShow = try? container.viewContext.fetch(request).first {
            delete(tvShow)
        }
    }
    
    /// Called when there is a change on the store to be synchronized across all devices
    /// - Parameter notification: The notification to observe (persistent store remote change)
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    /// Creates a new tag in the view context
    /// - Parameters:
    ///   - isMovieTag: Boolean value to know if the tag created is a movie or a show tag
    ///   - name: The name of the created tag
    func newTag(isMovieTag: Bool, name: String) -> Bool {
        var shouldCreate = fullAppPurchased
        
        if !shouldCreate {
            shouldCreate = count(for: Tag.fetchRequest()) < 3
        }
        
        guard shouldCreate else { return false }
        
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = name
        tag.isMovieTag = isMovieTag
        save()
        
        return true
    }
    
    /// Fetches the missing tags frome the view context for a given movie
    /// - Parameter movie: The movie to fetch missing tags from
    /// - Returns: The movie tags that can be attributed to the movie
    func missingTags(from movie: Movie) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        
        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(movie.movieTags)
        
        return difference.sorted().filter { $0.isMovieTag == true }
    }
    
    /// Fetches the missing tags frome the view context for a given tv show
    /// - Parameter tvShow: The tv show to fetch missing tags from
    /// - Returns: The tv show  tags that can be attributed to the tv show
    func missingTags(from tvShow: TvShow) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        
        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(tvShow.showTags)
        
        return difference.sorted().filter { $0.isMovieTag == false }
    }
    
    /// Fetches the movies from the view context by applying given predicates
    /// - Parameter watched: If the movies to fetch are watched or not
    /// - Returns: The movies matching the predicates
    @MainActor func fetchMovies(watched: Bool? = nil) -> [Movie] {
        var predicates = getAllPredicates()
        
        if let watched {
            let watchedPredicate = NSPredicate(format: "watched = %@", NSNumber(value: watched))
            predicates.append(watchedPredicate)
        }
        
        let request = Movie.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        switch sortOrder {
        case .priority:
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false), NSSortDescriptor(key: "title", ascending: true)]
        case .title:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
        
        let allMovies = (try? container.viewContext.fetch(request)) ?? []
        
        return allMovies
    }
    
    /// Fetches the tv shows from the view context by applying given predicates
    /// - Parameter watched: If the shows to fetch are watched or not
    /// - Returns: The tv shows matching the predicates
    @MainActor func fetchTvShows(watched: Bool? = nil) -> [TvShow] {
        var predicates = getAllPredicates()
        
        if let watched {
            let watchedPredicate = NSPredicate(format: "watched = %@", NSNumber(value: watched))
            predicates.append(watchedPredicate)
        }
        
        let request = TvShow.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        switch sortOrder {
        case .priority:
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false), NSSortDescriptor(key: "title", ascending: true)]
        case .title:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
        
        let allShows = (try? container.viewContext.fetch(request)) ?? []
        
        return allShows
    }
    
    /// Gets all predicates to apply to a show or movie request
    /// - Returns: The predicates applyable to a fetch request
    func getAllPredicates() -> [NSPredicate]  {
        let filter = selectedFilter ?? .movies
        
        var predicates = [NSPredicate]()
        
        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        }
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        
        if trimmedSearchText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedSearchText)
            let genresPredicate = NSPredicate(format: "genres CONTAINS[c] %@", trimmedSearchText)
            let actorsPredicate = NSPredicate(format: "actors.name CONTAINS[c] %@", trimmedSearchText)
            let directorsPredicate = NSPredicate(format: "directors.name CONTAINS[c] %@", trimmedSearchText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, genresPredicate, actorsPredicate, directorsPredicate])
            predicates.append(combinedPredicate)
        }
        
        if filterEnabled {
            if filterPriority >= 0 {
                let priorityPredicate = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityPredicate)
            }
            
            if filterStatus != .all {
                let lookForWatched = filterStatus == .watched
                let statusPredicate = NSPredicate(format: "watched = %@", NSNumber(value: lookForWatched))
                predicates.append(statusPredicate)
            }
        }
        
        return predicates
    }
    
    /// Checks if a content is already saved in the view context
    /// - Parameters:
    ///   - id: The id of the content to check
    ///   - typeOfContent: The type of content to check movie or show
    /// - Returns: True if already saved, or false if it isn't
    func isContentAlreadySaved(id: Int, typeOfContent: TypeOfContent) -> Bool {
        switch typeOfContent {
        case .movies:
            let predicate = NSPredicate(format: "id == %d", id)
            let request = Movie.fetchRequest()
            request.predicate = predicate
            let allMovies = (try? container.viewContext.fetch(request)) ?? []
            return !allMovies.isEmpty
        case .shows:
            let predicate = NSPredicate(format: "id == %d", id)
            let request = TvShow.fetchRequest()
            request.predicate = predicate
            let allShows = (try? container.viewContext.fetch(request)) ?? []
            return !allShows.isEmpty
        }
    }
    
    /// Checks if a tv show is watched
    /// - Parameter show: The tv show to check
    /// - Returns: True if already watched, false if it isn"t
    func isShowWatched(show: TvShow) -> Bool {
        for showSeason in show.showSeasons {
            if !showSeason.watched {
                return false
            }
        }
        return true
    }
    
    /// Checks if a season is watched
    /// - Parameter season: The tv show's season to check
    /// - Returns: True if already watched, false if it isn"t
    func isSeasonWatched(season: ShowSeason) -> Bool {
        for showEpisode in season.seasonEpisodes {
            if !showEpisode.watched {
                return false
            }
        }
        return true
    }
    
    /// Tries to create a movie from spotlight search
    /// - Parameter uniqueIdentifier: The core data unique identifier
    /// - Returns: If successful a Movie object else nil
    func movie(with uniqueIdentifier: String) -> Movie? {
        guard let url = URL(string: uniqueIdentifier) else { return nil }
        
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else { return nil }
        
        return try? container.viewContext.existingObject(with: id) as? Movie
    }
    
    /// Tries to create a tv show from spotlight search
    /// - Parameter uniqueIdentifier: The core data unique identifier
    /// - Returns: If successful a TvShow object else nil
    func tvShow(with uniqueIdentifier: String) -> TvShow? {
        guard let url = URL(string: uniqueIdentifier) else { return nil }
        
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else { return nil }
        
        return try? container.viewContext.existingObject(with: id) as? TvShow
    }
    
    /// Returns a configured fetch request to retrieve the highest-priority
    /// unwatched movies, limited to the specified number.
    ///
    /// This method is optimized for lightweight data retrieval in contexts where
    /// only a small subset of items is needed — such as WidgetKit timelines,
    /// background refreshes, or quick home-screen previews.
    /// Movies are filtered to include only those not marked as `watched`,
    /// and sorted in descending priority (highest priority first).
    ///
    /// - Parameter count: The maximum number of movies to return.
    /// - Returns: An `NSFetchRequest<Movie>` fetching at most `count` unwatched movies.
    func fetchRequestForTopMovies(count: Int) -> NSFetchRequest<Movie> {
        let request = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "watched = false")

        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.priority, ascending: false)]

        request.fetchLimit = count
        return request
    }
    
    /// Returns a configured fetch request to retrieve the highest-priority
    /// unwatched TV shows, limited to the specified number.
    ///
    /// This is used by WidgetKit to avoid loading entire collections of shows.
    /// Only unwatched items are included, and results are sorted by priority
    /// (highest first), ensuring that widgets display the most relevant content.
    ///
    /// - Parameter count: The maximum number of shows to return.
    /// - Returns: An `NSFetchRequest<TvShow>` fetching at most `count` unwatched shows.
    func fetchRequestForTopTvShows(count: Int) -> NSFetchRequest<TvShow> {
        let request = TvShow.fetchRequest()
        request.predicate = NSPredicate(format: "watched = false")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TvShow.priority, ascending: false)]
        request.fetchLimit = count
        return request
    }
    
    /// Executes the provided fetch request synchronously on the main `viewContext`.
    ///
    /// This utility ensures a lightweight and safe data access layer for modular
    /// parts of the app such as widgets, extensions, previews, or quick-lookup
    /// functions. If the fetch fails for any reason, an empty array is returned,
    /// allowing callers to remain simple and avoid repetitive `do/catch` blocks.
    ///
    /// - Parameter fetchRequest: The typed Core Data fetch request to execute.
    /// - Returns: The fetched objects, or an empty array if the operation fails.
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
}
