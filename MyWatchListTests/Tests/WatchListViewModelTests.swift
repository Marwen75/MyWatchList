//
//  WatchListViewModelTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 21/10/2025.
//

import XCTest
import CoreData
@testable import MyWatchList

@MainActor
final class WatchListViewModelTests: MyWatchListBaseTestCase {
    var vm: WatchListViewModel!
    
    override func tearDown() {
        super.tearDown()
        vm = nil
    }
    
    func testWhenViewModelIsInitializedCustomTagsArrayShouldNotBeEmpty() async {
        dataManager.createSampleData()
        
        vm = WatchListViewModel(dataManager: dataManager)
        
        XCTAssertFalse(vm.movieTags.isEmpty, "There should be some movie tags after init.")
        XCTAssertFalse(vm.showTags.isEmpty, "There should be some tv show tags after init.")
    }
    
    func testWhenRenamingTagNewNameShouldBeSaved() async {
        dataManager.createSampleData()
        
        vm = WatchListViewModel(dataManager: dataManager)
        vm.rename( vm.movieTags[0])
        vm.tagName = "test"
        vm.completeRename()
        
        XCTAssertTrue(vm.movieTags.contains(where: {$0.name == "test"}), "The movie tags array should contain the 'test' tag.")
    }
    
    func testDeleteMovieShouldRemoveItFromCoreData() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        let initialCount = dataManager.fetchMovies().count
        XCTAssertGreaterThan(initialCount, 0)
        
        vm.deleteMovie(atOffsets: IndexSet(integer: 0))
        
        let newCount = dataManager.fetchMovies().count
        XCTAssertEqual(newCount, initialCount - 1, "After deletion the movie deleted should not be here anymore.")
    }
    
    func testDeleteTvShowShouldRemoveItFromCoreData() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        let initialCount = dataManager.fetchTvShows().count
        
        vm.deleteTvShow(atOffsets: IndexSet(integer: 0))
        
        let newCount = dataManager.fetchTvShows().count
        XCTAssertEqual(newCount, initialCount - 1, "After deletion the tv show deleted should not be here anymore.")
    }
    
    func testDeleteMovieTagShouldRemoveItFromCoreData() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        let initialCount = vm.movieTags.count
        
        vm.deleteMovieTag(IndexSet(integer: 0))
        
        let newCount = vm.movieTags.count
        XCTAssertEqual(newCount, initialCount - 1, "After deletion the movie tag deleted should not be here anymore.")
    }
    
    func testDeleteShowTagShouldRemoveItFromCoreData() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        let initialCount = vm.showTags.count
        
        vm.deleteShowTag(IndexSet(integer: 0))
        
        let newCount = vm.showTags.count
        XCTAssertEqual(newCount, initialCount - 1, "After deletion the tv show tag deleted should not be here anymore.")
    }
    
    func testIfFiltersAreOnMovieShouldBeFetchedWithTheCorrectPredicates() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        vm.filterEnabled = true
        vm.filterPriority = 2
        
        XCTAssertEqual(dataManager.fetchMovies().count, 1, "Fetching movies with filter priority 2 should return one movie from the sample data.")
        
        vm.filterStatus = .unwatched
        
        XCTAssertEqual(dataManager.fetchMovies().count, 1, "Fetching movies with priority 2 and status unwatched should return one movie from samples.")
    }
    
    func testIfSearchTextIsNotEmptyContentShouldBeFetchedWithTheCorrectPredicate() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        vm.searchText = "Avengers"
        
        XCTAssertEqual(dataManager.fetchMovies().count, 1, "Fetching movies with 'Avengers' in search text should return one movie.")
    }
    
    func testIfCustomTagIsSelectedContentShouldBeFetchedWithTheCorrectPredicate() async throws {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        vm.selectedFilter = vm.movieTags[0]
        
        XCTAssertEqual(dataManager.fetchMovies().count, 1, "Fetching movies with a custom tag selected should return one movie.")
    }
    
    func testIfAShowIsNotWatchedSeasonsAndEpisodesShouldNotBeMarkedAsSuch() async {
        dataManager.createSampleData()
        vm = WatchListViewModel(dataManager: dataManager)
        
        let show = dataManager.fetchTvShows()[0]
        
        XCTAssertFalse(dataManager.isShowWatched(show: show), "If a show is not marked as watch this should return false")
        XCTAssertFalse(dataManager.isSeasonWatched(season: show.showSeasons[0]), "If a season is not marked as watch this should return false")
    }
}
