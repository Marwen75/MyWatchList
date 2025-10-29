//
//  SearchViewModelTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 15/10/2025.
//

import XCTest
@testable import MyWatchList

final class SearchViewModelTests: MyWatchListBaseTestCase {
    var searchVm: SearchViewModel!
    
    override func tearDown() async throws {
        try await super.tearDown()
        searchVm = nil
    }
    
    func testSearchMoviesShouldGiveOneContentToTheViewModelArray() async throws {
        searchVm = SearchViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .searchMovie))
        
        await searchVm.search()
        
        XCTAssertEqual(searchVm.tmdbContents.count, 1)
    }
    
    func testSearchTvShowsShouldGiveOneContentToTheViewModelArray() async throws {
        searchVm = SearchViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .searcnTvShow))
        
        searchVm.selectedTypeOfContent = .shows
        
        await searchVm.search()
        
        XCTAssertEqual(searchVm.tmdbContents.count, 1)
    }
    
    func testIfAMovieIsNotAlreadyInTheWatchListItShouldReturnFalse() async throws {
        searchVm = SearchViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .searchMovie))
        dataManager.createSampleData()
        
        await searchVm.search()
        
        guard let contentId = searchVm.tmdbContents.first?.id else { return XCTFail("No content found") }
        
        XCTAssertFalse(searchVm.isContentAlreadyInList(contentId: contentId))
    }
    
    func testSearchATvShowThatIsAlreadyInListShouldReturnTrue() async throws {
        searchVm = SearchViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .searcnTvShow))
        searchVm.selectedTypeOfContent = .shows
        dataManager.createSampleData()
        
        await searchVm.search()
        
        guard let contentId = searchVm.tmdbContents.first?.id else { return XCTFail("No content found") }
        
        XCTAssertTrue(searchVm.isContentAlreadyInList(contentId: contentId))
    }
    
    func testSearchMoviesWithBadUrlShouldResultWithAnError() async throws {
        searchVm = SearchViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .error))
        
        await searchVm.search()
        
        XCTAssertFalse(searchVm.errorMessage.isEmpty)
    }
}
