//
//  TagTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 13/10/2025.
//

import XCTest
import CoreData
@testable import MyWatchList

final class TagTests: MyWatchListBaseTestCase {
    func testCreatingTagsAndMovies() {
        let count = 10
        let movieCount = count * count
        
        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)
            
            for _ in 0..<count {
                let movie = Movie(context: managedObjectContext)
                tag.addToMovies(movie)
            }
        }
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataManager.count(for: Movie.fetchRequest()), movieCount, "Expected \(movieCount) movies.")
    }
    
    func testCreatingTagsAndTvShows() {
        let count = 10
        let showCount = count * count
        
        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)
            
            for _ in 0..<count {
                let show = TvShow(context: managedObjectContext)
                tag.addToShows(show)
            }
        }
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataManager.count(for: TvShow.fetchRequest()), showCount, "Expected \(showCount) movies.")
    }
    
    func testDeletingTagsDoesNotDeleteMovies() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)
        
        dataManager.delete(tags[0])
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), 11, "Expected 11 tags after deleting 1.")
        XCTAssertEqual(dataManager.count(for: Movie.fetchRequest()), 2, "Expected 2 movies after deleting a tag.")
    }
    
    func testDeletingTagsDoesNotDeleteTvShows() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)
        
        dataManager.delete(tags[0])
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), 11, "Expected 11 tags after deleting 1.")
        XCTAssertEqual(dataManager.count(for: TvShow.fetchRequest()), 1, "Expected 1 tv show after deleting a tag.")
    }
    
    func testFetchingMissingTagsForAMovieShouldReturnSomething() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<Movie>(entityName: "Movie")
        let movies = try managedObjectContext.fetch(request).sorted()
        
        XCTAssertEqual(dataManager.missingTags(from: movies[1]).count, 6, "There should be six missing tags for the second movie of the movie array.")
    }
    
    func testFetchingMissingTagsForAShowWithAllTagsShouldReturnZero() throws {
        dataManager.createSampleData()
        
        let request = NSFetchRequest<TvShow>(entityName: "TvShow")
        let shows = try managedObjectContext.fetch(request)
        
        XCTAssertEqual(dataManager.missingTags(from: shows[0]).count, 0, "There should be no tags missing for the show.")
    }
    
    func testDeleteAllContentShouldLeaveNoTagsLeft() {
        dataManager.createSampleData()
        
        dataManager.deleteAll()
        
        XCTAssertEqual(dataManager.count(for: Tag.fetchRequest()), 0, "After deleting all tags there should be nothing left.")
    }
    
    func testCreatingNewTagForMovieWithCustomNameShouldAppearOnStore() {
        dataManager.newTag(isMovieTag: true, name: "Movie")
        
        let movie = Movie(context: managedObjectContext)
        
        XCTAssertEqual(dataManager.missingTags(from: movie)[0].tagName, "Movie", "The new tag created with a custom name should appearing on the missing tags.")
    }
}
