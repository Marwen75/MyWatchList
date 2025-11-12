//
//  MyWatchListUITests.swift
//  MyWatchListUITests
//
//  Created by Marwen Haouacine on 28/10/2025.
//

import XCTest
import StoreKit

final class MyWatchListUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    @MainActor
    func testAppStartsWithNavigationBar() throws {
        app.waitForElementToAppear(app.navigationBars.element)
    }
    
    @MainActor
    func testAppStartsWithTabBar() throws {
        app.waitForElementToAppear(app.tabBars.element)
    }
    
    @MainActor
    func testAppHasBasicButtonsOnLaunch() throws {
        let navBarButtons = app.navigationBars.buttons
        let tabBarButtons = app.tabBars.buttons
        
        XCTAssertEqual(navBarButtons.count, 4, "There should be 4 buttons inside the navigation bar.")
        XCTAssertEqual(tabBarButtons.count, 2, "There should be 2 buttons inside the tab bar.")
    }
    
    @MainActor
    func testAddMovieFromSearchShouldAppearInMainList() throws {
        let searchTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(searchTab.waitForExistence(timeout: 5))
        searchTab.tap()
        
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Alien romulus\n")
        
        let firstResultImage = app.images.matching(NSPredicate(format: "identifier BEGINSWITH %@", "searchResult_")).firstMatch
        XCTAssertTrue(firstResultImage.waitForExistence(timeout: 10), "Image from result should exist.")
        
        let firstResultIdentifier = firstResultImage.identifier
        let firstResultButton = app.buttons.containing(NSPredicate(format: "identifier == %@", firstResultIdentifier)).firstMatch
        XCTAssertTrue(firstResultButton.exists, "First parent button from poster should exist.")
        XCTAssertTrue(firstResultButton.isHittable, "First parent button from poster should be hittable.")
        firstResultButton.tap()
        
        let addButton = app.buttons["addMenuButton"]
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "The 'add' button should appear afeter scrolling.")
        addButton.tap()
        
        let mediumPriorityButton = app.buttons["priorityButton_1"]
        XCTAssertTrue(mediumPriorityButton.waitForExistence(timeout: 3), "Priority selection should appear after tapping the add menu.")
        mediumPriorityButton.tap()
        
        let watchlistTab = app.tabBars.buttons["wlTab"]
        XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3))
        watchlistTab.tap()
        
        let movieCell = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Alien")).firstMatch
        XCTAssertTrue(movieCell.waitForExistence(timeout: 5), "The movie should appear in the watchlist.")
        
        movieCell.tap()
        
        app.swipeUp()
    }
    
    @MainActor
    func testAddTvShowFromSearchShouldAppearInMainList() throws {
        let searchTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(searchTab.waitForExistence(timeout: 3))
        searchTab.tap()
        
        let tvSegment = app.buttons["segmentedButton_shows"]
        XCTAssertTrue(tvSegment.waitForExistence(timeout: 3))
        tvSegment.tap()
        
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Breaking Bad\n")
        
        let firstResultImage = app.images.matching(NSPredicate(format: "identifier BEGINSWITH %@", "searchResult_")).firstMatch
        XCTAssertTrue(firstResultImage.waitForExistence(timeout: 10), "The image from the tv show should exist")
        
        let firstResultIdentifier = firstResultImage.identifier
        let firstResultButton = app.buttons.containing(NSPredicate(format: "identifier == %@", firstResultIdentifier)).firstMatch
        XCTAssertTrue(firstResultButton.exists)
        XCTAssertTrue(firstResultButton.isHittable)
        firstResultButton.tap()
        
        let addButton = app.buttons["addMenuButton"]
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(addButton.waitForExistence(timeout: 10))
        addButton.tap()
        
        let highPriorityButton = app.buttons["priorityButton_2"]
        XCTAssertTrue(highPriorityButton.waitForExistence(timeout: 3), "Priority selection should appear after tapping the add menu.")
        highPriorityButton.tap()
        
        let watchlistTab = app.tabBars.buttons["wlTab"]
        XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3))
        watchlistTab.tap()
        
        let filterButton = app.navigationBars.buttons.element(boundBy: 1)
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5), "Filter button should exist.")
        filterButton.tap()
        
        let tvShowsButton = app.cells.element(boundBy: 2)
        XCTAssertTrue(tvShowsButton.waitForExistence(timeout: 5), "Tv filter button from sheet view should exist.")
        tvShowsButton.tap()
        
        let showCell = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Breaking Bad")).firstMatch
        XCTAssertTrue(showCell.waitForExistence(timeout: 8), "Added show should exist in the watchlist.")
        
        showCell.tap()
        
        app.swipeUp()
        
        let showName = "Breaking_Bad"
        let firstSeasonCell = app.buttons["seasonCell_\(showName)_1"]
        XCTAssertTrue(firstSeasonCell.waitForExistence(timeout: 5), "First season should exist.")
        firstSeasonCell.tap()
        
        app.swipeUp()
        
        let firstEpisodeCell = app.buttons["episodeCell_1"]
        XCTAssertTrue(firstEpisodeCell.waitForExistence(timeout: 5), "First episode should exist.")
        firstEpisodeCell.tap()
        
        app.swipeUp()
    }
}

extension XCUIApplication {
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 3) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "\(element) did not appear in time")
    }
}
