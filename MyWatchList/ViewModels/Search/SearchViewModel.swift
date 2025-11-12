//
//  SearchViewModel.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import Foundation
import CoreData

@dynamicMemberLookup
class SearchViewModel: ObservableObject {
    var dataManager: DataManager
    var networkManager: NetworkManagerProtocol
    var hasMorePages: Bool {
        currentPage < totalPages
    }
    
    @Published var searchText = ""
    @Published var tmdbContents: [TmdbContent] = []
    @Published var typeOfContent: [TypeOfContent] = [.movies, .shows]
    @Published var selectedTypeOfContent = TypeOfContent.movies
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var appError: AppError?
    @Published var isFetchingNextPage = false
    
    init(dataManager: DataManager, networkManager: NetworkManagerProtocol) {
        self.dataManager = dataManager
        self.networkManager = networkManager
    }
    
    /// Searches for results matching the user's research
    @MainActor
    func search() async {
        do {
            switch selectedTypeOfContent {
            case .movies:
                let searchResults = try await networkManager.fetch(.movies(query: searchText, page: currentPage))
                
                totalPages = searchResults.totalPages
                tmdbContents.append(contentsOf: searchResults.results)
                tmdbContents = tmdbContents.uniqued().filter { $0.posterPath != nil }
            default:
                let searchResults = try await networkManager.fetch(.shows(query: searchText, page: currentPage))
                
                totalPages = searchResults.totalPages
                tmdbContents.append(contentsOf: searchResults.results)
                tmdbContents = tmdbContents.uniqued().filter { $0.posterPath != nil }
            }
        } catch {
            appError = AppError(error)
        }
    }
    
    /// Fetches the next page of search results from TMDB.
    ///
    /// This method is responsible for handling the infinite scrolling behavior.
    /// It ensures that only one pagination request is performed at a time and
    /// automatically resets the fetching state when the task completes — whether it succeeds or fails.
    @MainActor
    func fetchNextPage() async {
        guard !isFetchingNextPage else { return }
        isFetchingNextPage = true
        defer { isFetchingNextPage = false }
        
        currentPage += 1
        await search()
    }
    
    /// Checks if a content is alreadu in the user's watch list
    /// - Parameter contentId: The id of the content to check
    /// - Returns: True if content is in list, false otherwise
    func isContentAlreadyInList(contentId: Int) -> Bool {
        if selectedTypeOfContent == .movies {
            let moviesRequest = Movie.fetchRequest()
            let movies = (try? dataManager.container.viewContext.fetch(moviesRequest)) ?? []
            
            var movieIds : [Int] {
                movies.map { Int($0.id) }
            }
            
            return movieIds.contains(where: { $0 == contentId })
        } else {
            let showsRequest = TvShow.fetchRequest()
            let shows = (try? dataManager.container.viewContext.fetch(showsRequest)) ?? []
            
            var showIds: [Int] {
                shows.map { Int($0.id) }
            }
            
            return showIds.contains(where: { $0 == contentId })
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<NetworkManagerProtocol, Value>) -> Value {
        networkManager[keyPath: keyPath]
    }
}
