//
//  SearchDetailViewModel.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import Foundation
import Combine

@dynamicMemberLookup
@MainActor
class SearchDetailViewModel: ObservableObject {
    var networkManager: NetworkManagerProtocol
    var dataManager: DataManager
    var tmdbId: Int
    var typeOfContent: TypeOfContent
    
    @Published var tmdbContent: TmdbContent?
    @Published var castMembers: [Cast] = []
    @Published var directors: [Cast] = []
    @Published var creators: [Creator] = []
    @Published var seasons: [Season] = []
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var contentAlreadySaved = false
    @Published var appError: AppError?
    #if DEBUG
    @Published var isLoaded = false
    #endif
    
    init(dataManager: DataManager, networkManager: NetworkManagerProtocol, tmdbId: Int, typeOfContent: TypeOfContent) {
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.tmdbId = tmdbId
        self.typeOfContent = typeOfContent
        
        contentAlreadySaved = dataManager.isContentAlreadySaved(id: tmdbId, typeOfContent: typeOfContent)
        
        Task {
            await fetchDetails()
            await fetchCredits()
            #if DEBUG
            self.isLoaded = true
            #endif
        }
    }
    
    /// Fetches the details based on the type of content selected
    func fetchDetails() async {
        do {
            switch typeOfContent {
            case .movies:
                let movieDetails = try await networkManager.fetch(.movieDetails(id: String(tmdbId)))
                
                tmdbContent = movieDetails
            default:
                let tvShowDetails = try await networkManager.fetch(.tvShowDetails(id: String(tmdbId)))
                
                tmdbContent = tvShowDetails
                creators = tvShowDetails.creators ?? []
                await fetchSeasonDetails(tmdbContent: tvShowDetails)
            }
        } catch {
            appError = AppError(error)
        }
    }
    
    /// Fetches the season details for all seasons of a tv show
    /// - Parameter tmdbContent: The tv show to fetch seasons details from
    func fetchSeasonDetails(tmdbContent: TmdbContent) async {
        do {
            if let contentSeasons = tmdbContent.seasons {
                let seasonsFiltered = contentSeasons.filter({ $0.airDate != nil && $0.name != "Specials" && $0.seasonNumber != 0 }) 
                for i in 0..<seasonsFiltered.count {
                    let season = try await networkManager.fetch(.seasonDetails(showId: String(tmdbId), seasonNumber: i + 1))
                    
                    seasons.append(season)
                }
            }
        } catch {
            appError = AppError(error)
        }
    }
    
    /// Fetches the credits from a content based on the selected type of content
    func fetchCredits() async {
        do {
            switch typeOfContent {
            case .movies:
                let credits = try await networkManager.fetch(.movieCredits(id: String(tmdbId)))
                
                castMembers = credits.cast
                directors = credits.crew.filter({ $0.job == "Director" })
            case .shows:
                let credits = try await networkManager.fetch(.showCredits(id: String(tmdbId)))
                
                castMembers = credits.cast
            }
        } catch {
            appError = AppError(error)
        }
    }
    
    /// Adds a content if the content is not already saved, deletes it otherwise
    /// - Parameter priority: The watch priority selected by the user for the content to add.
    func AddOrDeleteContent(withPriority priority: WatchPriority = .low) {
        switch typeOfContent {
        case .movies:
            if contentAlreadySaved {
                dataManager.deleteMovieWithId(Int64(tmdbId))
            } else {
                if let tmdbContent {
                    dataManager.createMovie(fromContent: tmdbContent,
                                            priority: priority,
                                            withCastMembers: castMembers,
                                            andDirectors: directors)
                }
            }
        case .shows:
            if contentAlreadySaved {
                dataManager.deleteShowWithId(Int64(tmdbId))
            } else {
                if let tmdbContent {
                    dataManager.createTvShow(fromContent: tmdbContent,
                                             priority: priority,
                                             withCastMembers: castMembers,
                                             creators: creators, andSeasons: seasons)
                }
            }
        }
        contentAlreadySaved = dataManager.isContentAlreadySaved(id: tmdbId, typeOfContent: typeOfContent)
    }
    
#if DEBUG
    /// Helper method for testing purposes, allows the test to wait for the end of data loading before continuing
    /// - Parameter timeout: The time out to apply to the deadline
    func waitUntilLoaded(timeout: UInt64 = 2_000_000_000) async {
        let deadline = DispatchTime.now().uptimeNanoseconds + timeout
        while !isLoaded && DispatchTime.now().uptimeNanoseconds < deadline {
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        }
    }
#endif
    
    subscript<Value>(dynamicMember keyPath: KeyPath<NetworkManagerProtocol, Value>) -> Value {
        networkManager[keyPath: keyPath]
    }
}
