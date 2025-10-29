//
//  SearchDetailViewModelTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 20/10/2025.
//

import XCTest
@testable import MyWatchList

@MainActor
final class SearchDetailViewModelTests: MyWatchListBaseTestCase {
    var vm: SearchDetailViewModel!

    override func tearDown() {
        super.tearDown()
        vm = nil
    }
    
    func testSearchDetailsForMovieShouldGiveTheCorrectDetails() async  {
        vm = SearchDetailViewModel(dataManager: dataManager,
                                   networkManager: MockNetworkManager(fileName: .movieDetails),
                                   tmdbId: 54138,
                                   typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        XCTAssertNotNil(vm.tmdbContent)
        XCTAssertEqual(vm.tmdbContent?.title, "Star Trek Into Darkness")
    }
    
    func testSearchDetailsForTvShowShouldGiveTheCorrectDetails() async  {
        vm = SearchDetailViewModel(dataManager: dataManager,
                                   networkManager: MockNetworkManager(fileName: .tvShowDetails),
                                   tmdbId: 1409,
                                   typeOfContent: .shows)
        
        await vm.waitUntilLoaded()
        
        XCTAssertNotNil(vm.tmdbContent)
        XCTAssertEqual(vm.tmdbContent?.name, "Sons of Anarchy")
    }
    
    func testSearchDetailsForMovieCreditsShouldReturnCredits() async {
        vm = SearchDetailViewModel(dataManager: dataManager,
                                   networkManager: MockNetworkManager(fileName: .movieCredits),
                                   tmdbId: 54138,
                                   typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        XCTAssertFalse(vm.castMembers.isEmpty)
        XCTAssertEqual(vm.castMembers.first?.name, "Chris Pine")
    }
    
    func testSearchDetailsForTvShowCreditsShouldReturnCredits() async {
        vm = SearchDetailViewModel(dataManager: dataManager,
                                   networkManager: MockNetworkManager(fileName: .tvShowCredits),
                                   tmdbId: 1409,
                                   typeOfContent: .shows)
        
        await vm.waitUntilLoaded()
        
        XCTAssertFalse(vm.castMembers.isEmpty)
        XCTAssertEqual(vm.castMembers.first?.name, "Charlie Hunnam")
    }
    
    func testIfAMovieIsAddedToTheWatchListItShouldBeVisibleOnTheStore() async {
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .movieDetails), tmdbId: 54138, typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        vm.AddOrDeleteContent()
        
        let isSaved = dataManager.isContentAlreadySaved(id: 54138, typeOfContent: .movies)
        
        XCTAssertTrue(isSaved)
    }
    
    func testIfAShowIsAddedToTheWatchListItShouldBeVisibleOnTheStore() async {
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .tvShowDetails), tmdbId: 1409, typeOfContent: .shows)
        
        await vm.waitUntilLoaded()
        
        vm.AddOrDeleteContent()
        
        let isSaved = dataManager.isContentAlreadySaved(id: 1409, typeOfContent: .shows)
        
        XCTAssertTrue(isSaved)
    }
    
    func testIfAShowIsAlreadyInTheWatchListItShouldBeRemoved() async {
        dataManager.createSampleData()
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .movieDetails), tmdbId: 1409, typeOfContent: .shows)
        
        await vm.waitUntilLoaded()
        
        vm.AddOrDeleteContent()
        
        let isSaved = dataManager.isContentAlreadySaved(id: 1409, typeOfContent: .shows)
        
        XCTAssertFalse(isSaved)
    }
    
    func testAddThenRemoveMovieShouldToggleSavedState() async {
        let tmdbId = 54138
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .movieDetails), tmdbId: tmdbId, typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        vm.AddOrDeleteContent()
        
        XCTAssertTrue(dataManager.isContentAlreadySaved(id: tmdbId, typeOfContent: .movies))
        
        vm.AddOrDeleteContent()
        
        XCTAssertFalse(dataManager.isContentAlreadySaved(id: tmdbId, typeOfContent: .movies))
    }
    
    func testSearchDetailsForMovieWithBadUrlShouldFail() async {
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: MockNetworkManager(fileName: .error), tmdbId: 54138, typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        XCTAssertFalse(vm.errorMessage.isEmpty)
    }
    
    func testSearchDetailsWhenNetworkFailsShouldSetErrorMessage() async {
        let failingNetwork = MockNetworkManager(fileName: .movieDetails, shouldFail: true, mockError: .badServerResponse)
        vm = SearchDetailViewModel(dataManager: dataManager, networkManager: failingNetwork, tmdbId: 54138, typeOfContent: .movies)
        
        await vm.waitUntilLoaded()
        
        XCTAssertFalse(vm.errorMessage.isEmpty)
    }
}
