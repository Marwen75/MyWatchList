//
//  DataManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import CoreData
import StoreKit

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
    
#if DEBUG
    /// For preview purposes only
    static var preview: DataManager = {
        let dataManager = DataManager(inMemory: true)
        dataManager.createSampleData()
        return dataManager
    }()
#endif
    
    
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
        }
        
        // Apply any changes that happen to the persisent store to our view context
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // Be notified when the store has changed
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator,
                                               queue: .main,
                                               using: remoteStoreChanged)
        
        
        container.loadPersistentStores { [weak self] _, error in
            if let error {
                fatalError("Fatal error while loading persistent stores: \(error.localizedDescription)")
            }
            
            // Initializing the spotlight delegate so the user can
            // search for an Movie or a Tv Show from his home screen
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(forStoreWith: description, coordinator: coordinator)
                }
                
                self?.spotlightDelegate?.startSpotlightIndexing()
            }
        }
    }
    
#if DEBUG
    func createSampleData() {
        container.viewContext.performAndWait {
            let viewContext = container.viewContext
            let movie = Movie(context: viewContext)
            movie.poster = "/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg"
            movie.title = "Avengers: Infinity War"
            movie.overview = "As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable power, and use them to inflict his twisted will on all of reality. Everything the Avengers have fought for has led up to this moment - the fate of Earth and existence itself has never been more uncertain."
            movie.budget = Int64(300000000)
            movie.genres = "Adventure, Action, Science Fiction"
            movie.id = Int64(86311)
            movie.releaseDate = "2018-04-25"
            movie.runTime = Int64(149)
            movie.trailerUrl = "6ZfuNTqbHE8"
            movie.voteAverage = 8.235
            movie.imdbUrl = "test"
            movie.priority = 2
            movie.watched = false
            
            let director = Director(context: viewContext)
            director.name = "Anthony Russo"
            director.id = Int64(19271)
            director.picture = "/xbINBnWn28YygYWUJ1aSAw0xPRv.jpg"
            
            let director2 = Director(context: viewContext)
            director2.name = "Joe Russo"
            director2.id = Int64(19272)
            director2.picture = "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg"
            movie.directors = NSSet(array: [director, director2])
            
            let actor = Actor(context: viewContext)
            actor.name = "Adam Test"
            actor.id = 1
            actor.picture = "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg"
            
            movie.actors = NSSet(array: [actor])
            
            let movie2 = Movie(context: viewContext)
            movie2.poster = "/lV5OpzAss1z06YNagOVap1I35mH.jpg"
            movie2.title = "Star Trek"
            movie2.overview = "The fate of the galaxy rests in the hands of bitter rivals. One, James Kirk, is a delinquent, thrill-seeking Iowa farm boy. The other, Spock, a Vulcan, was raised in a logic-based society that rejects all emotion. As fiery instinct clashes with calm reason, their unlikely but powerful partnership is the only thing capable of leading their crew through unimaginable danger, boldly going where no one has gone before. The human adventure has begun again."
            movie2.budget = Int64(150000000)
            movie2.genres = "Adventure, Action, Science Fiction"
            movie2.id = Int64(115575)
            movie2.releaseDate = "2009-05-06"
            movie2.runTime = Int64(127)
            movie2.trailerUrl = "pFVvigZ5wQY"
            movie2.voteAverage = 7.425
            movie2.priority = 0
            movie2.watched = false
            
            let show = TvShow(context: viewContext)
            show.poster = "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg"
            show.title = "Sons of Anarchy"
            show.overview = "The Sons of Anarchy (SOA) are an outlaw motorcycle club with many charters in the United States and overseas. The show focused on the original and founding charter, Sons of Anarchy Motorcycle Club, Redwood Original, often referred to by the acronym SAMCRO, Sam Crow, or simply Redwood Charter. The charter operates both legal and illegal businesses in the small town of Charming, California. They combine gun-running and a garage, and involvement in porn film industry. Clay, the charter president, likes it old school and violent; while Jax, his stepson and the club's VP, has thoughts about changing the way things are done. Their conflict has effects on both the club and their personal relationship, especially when Jax goes on a personal quest to cleanse the SAMCRO name and image."
            show.inProduction = false
            show.genres = "Crime, Drama"
            show.id = Int64(1409)
            show.firstAirDate = "2008-09-03"
            show.lastAirDate = "2014-12-09"
            show.numberOfEpisodes = Int64(92)
            show.numberOfSeasons = Int64(7)
            show.trailerUrl = "paBZJJXUEtg"
            show.voteAverage = 8.419
            show.inProduction = false
            show.imdbUrl = "test"
            let creator = Director(context: viewContext)
            creator.name = "Kurt Sutter"
            creator.id = Int64(200043)
            creator.picture = "/A4c9xpj2VuZXGvSv6z1S912Xwnd.jpg"
            
            let season1 = ShowSeason(context: viewContext)
            season1.id = Int64(3684)
            season1.airDate = "2008-09-03"
            season1.name = "Season 1"
            season1.overview = "The Sons of Anarchy live, ride, and die for brotherhood. But as the club's leader Clay Morrow and his wife Gemma steer them in an increasingly lawless direction, Gemma's son Jax is torn between loyalty and the legacy."
            season1.seasonNumber = Int64(1)
            season1.voteAverage = 8.1
            season1.poster = "/eZJPW8G7o0b2fH7GC7Av4MOKTj3.jpg"
            season1.watched = false
            
            let episode1 = ShowEpisode(context: viewContext)
            episode1.airDate = "2008-09-03"
            episode1.id = 63924
            episode1.name = "Pilot"
            episode1.overview = "When a rival club cleans out and then destroys their illegal arms warehouse, SAMCRO (Sons of Anarchy Motorcycle Club, Redwood Original) executes their own sense of justice in retrieving their guns. Meanwhile, family issues take center stage with a medical emergency involving Jax Teller's newborn son."
            episode1.episodeNumber = Int64(1)
            episode1.runTime = 57
            episode1.voteAverage = 8.4
            episode1.stillPath = "/jc2RFJIJBFqsMpxnCD6VParg8Rj.jpg"
            episode1.watched = false
            
            season1.episodes = NSSet(array: [episode1])
            
            
            show.seasons = NSSet(array: [season1])
            
            show.directors = NSSet(array: [creator])
            
            show.actors = NSSet(array: [actor])
            
            for i in 0...5 {
                let tag = Tag(context: viewContext)
                tag.id = UUID()
                tag.name = String(i)
                tag.isMovieTag = true
                tag.movies = NSSet(array: [movie])
            }
            
            for i in 0...5 {
                let tag = Tag(context: viewContext)
                tag.id = UUID()
                tag.name = "Tag number \(i)"
                tag.isMovieTag = false
                tag.shows = NSSet(array: [show])
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save sample data: \(error.localizedDescription)")
            }
        }
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // IMPORTANT: When performing a batch delete we need to make sure we read the result back
        // then merge all the changes from that result back into our live view context
        // so that the two stay in sync.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        delete(request2)
        
        let request3: NSFetchRequest<NSFetchRequestResult> = TvShow.fetchRequest()
        delete(request3)
        
        save()
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
#endif
    
    /// Saves the view context only if changes were made
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
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
    
    /// Creates a movie in the view context using fetched data
    /// - Parameters:
    ///   - content: The content fetched from the api
    ///   - castMembers: Cast members relative to the content fetched
    ///   - directors: Directors relative to the content fetched
    func createMovie(fromContent content: TmdbContent, priority: WatchPriority = .low, withCastMembers castMembers: [Cast], andDirectors directors: [Cast]) {
        let movie = Movie(context: container.viewContext)
        
        movie.poster = content.posterPath
        movie.title = content.title
        movie.overview = content.overview
        movie.budget = Int64(content.budget ?? 0)
        if let genres = content.genres {
            movie.genres = genres.map(\.self.name).joined(separator: ", ")
        }
        movie.id = Int64(content.id)
        movie.releaseDate = content.releaseDate
        movie.runTime = Int64(content.runtime ?? 0)
        if let videos = content.videos, let video = videos.results.first(where: {$0.type == "Trailer"}) {
            movie.trailerUrl = video.key
        }
        movie.voteAverage = content.voteAverage ?? 0
        movie.priority = priority.rawValue
        movie.watched = false
        
        var actors: [Actor] = []
        
        /// We need to add a rank to the actors so we can sort them in the good order
        castMembers.enumerated().forEach { i, castMember in
            let actor = Actor(context: container.viewContext)
            actor.rank = Int32(i)
            actor.id = Int64(castMember.id)
            actor.name = castMember.name
            actor.picture = castMember.profilePath
            actors.append(actor)
        }
        
        movie.actors = NSSet(array: actors)
        
        var directorsToSave: [Director] = []
        
        for director in directors {
            let directorObject = Director(context: container.viewContext)
            directorObject.id = Int64(director.id)
            directorObject.name = director.name
            directorObject.picture = director.profilePath
            directorsToSave.append(directorObject)
        }
        
        movie.directors = NSSet(array: directorsToSave)
        
        save()
    }
    
    /// Creates a movie in the view context using fetched data
    /// - Parameters:
    ///   - content: The content fetched from the api
    ///   - castMembers: Cast members relative to the content fetched
    ///   - creators: Creators relative to the content fetched
    ///   - seasons: Seasons relative to the content fetched
    func createTvShow(fromContent content: TmdbContent, priority: WatchPriority = .low, withCastMembers castMembers: [Cast], creators: [Creator], andSeasons seasons: [Season]) {
        let show = TvShow(context: container.viewContext)
        
        show.poster = content.posterPath
        show.title = content.name
        show.overview = content.overview
        show.inProduction = content.inProduction ?? false
        if let genres = content.genres {
            show.genres = genres.map(\.self.name).joined(separator: ", ")
        }
        show.id = Int64(content.id)
        show.firstAirDate = content.firstAirDate
        show.lastAirDate = content.lastAirDate
        show.numberOfEpisodes = Int64(content.numberOfEpisodes ?? 0)
        show.numberOfSeasons = Int64(content.numberOfSeasons ?? 0)
        if let videos = content.videos, let video = videos.results.first(where: {$0.type == "Trailer"}) {
            show.trailerUrl = video.key
        }
        show.voteAverage = content.voteAverage ?? 0
        show.priority = priority.rawValue
        show.watched = false
        
        var directorsToSave: [Director] = []
        
        for creator in creators {
            let directorObject = Director(context: container.viewContext)
            directorObject.id = Int64(creator.id)
            directorObject.name = creator.name
            directorObject.picture = creator.profilePath
            directorsToSave.append(directorObject)
        }
        
        show.directors = NSSet(array: directorsToSave)
        
        var actors: [Actor] = []
        
        /// We need to add a rank to the actors so we can sort them in the good order
        castMembers.enumerated().forEach { i, castMember in
            let actor = Actor(context: container.viewContext)
            actor.rank = Int32(i)
            actor.id = Int64(castMember.id)
            actor.name = castMember.name
            actor.picture = castMember.profilePath
            actors.append(actor)
        }
        
        show.actors = NSSet(array: actors)
        
        var seasonsToSave: [ShowSeason] = []
        
        /// We give a rank to the seasons in case the season number is missing so it still appears in the right order
        seasons.enumerated().forEach { i, season in
            if season.name != "Specials" || season.airDate != nil {
                let showSeason = ShowSeason(context: container.viewContext)
                showSeason.rank = Int64(i)
                showSeason.id = Int64(season.id)
                showSeason.airDate = season.airDate
                showSeason.name = season.name
                showSeason.overview = season.overview
                showSeason.seasonNumber = Int64(season.seasonNumber ?? 0)
                showSeason.voteAverage = season.voteAverage ?? 0
                showSeason.poster = season.posterPath
                var seasonEpisodes: [ShowEpisode] = []
                season.episodes?.enumerated().forEach { i, episode in
                    let showEpisode = ShowEpisode(context: container.viewContext)
                    showEpisode.rank = Int64(i)
                    showEpisode.id = Int64(episode.id)
                    showEpisode.airDate = episode.airDate
                    showEpisode.episodeNumber = Int64(episode.episodeNumber ?? 0)
                    showEpisode.name = episode.name
                    showEpisode.overview = episode.overview
                    showEpisode.stillPath = episode.stillPath
                    showEpisode.voteAverage = episode.voteAverage ?? 0
                    showEpisode.runTime = Int64(episode.runtime ?? 0)
                    seasonEpisodes.append(showEpisode)
                }
                showSeason.episodes = NSSet(array: seasonEpisodes)
                
                seasonsToSave.append(showSeason)
            }
        }
        
        show.seasons = NSSet(array: seasonsToSave)
        
        save()
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
}
