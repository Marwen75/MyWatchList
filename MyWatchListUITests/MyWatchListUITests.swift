//
//  MyWatchListUITests.swift
//  MyWatchListUITests
//
//  Created by Marwen Haouacine on 28/10/2025.
//

import XCTest

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
        
        XCTAssertEqual(navBarButtons.count, 2, "There should be 2 buttons inside the navigation bar.")
        XCTAssertEqual(tabBarButtons.count, 2, "There should be 2 buttons inside the tab bar.")
    }
    
    
    @MainActor
    func testAddMovieFromSearchShouldAppearInMainList() throws {
        let searchTab = app.tabBars.buttons["Search"]
        XCTAssertTrue(searchTab.waitForExistence(timeout: 3))
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

        let addButton = app.buttons["addButton"]
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "The 'add' button should appear afeter scrolling.")
        addButton.tap()

        let watchlistTab = app.tabBars.buttons["Watch list"]
        XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3))
        watchlistTab.tap()

        let movieCell = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Star Trek")).firstMatch
        XCTAssertTrue(movieCell.waitForExistence(timeout: 5), "The movie should appear in the watchlist.")
        
        movieCell.tap()
        
        app.swipeUp()
    }
    
    @MainActor
    func testAddTvShowFromSearchShouldAppearInMainList() throws {
        let searchTab = app.tabBars.buttons["Search"]
        XCTAssertTrue(searchTab.waitForExistence(timeout: 3))
        searchTab.tap()
        
        let tvSegment = app.segmentedControls.buttons["Tv Shows"]
        XCTAssertTrue(tvSegment.waitForExistence(timeout: 3))
        tvSegment.tap()
        
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Sons of anarchy\n")
        
        let firstResultImage = app.images.matching(NSPredicate(format: "identifier BEGINSWITH %@", "searchResult_")).firstMatch
        XCTAssertTrue(firstResultImage.waitForExistence(timeout: 10), "The image from the tv show should exist")
        
        let firstResultIdentifier = firstResultImage.identifier
        let firstResultButton = app.buttons.containing(NSPredicate(format: "identifier == %@", firstResultIdentifier)).firstMatch
        XCTAssertTrue(firstResultButton.exists)
        XCTAssertTrue(firstResultButton.isHittable)
        firstResultButton.tap()
        
        let addButton = app.buttons["addButton"]
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(addButton.waitForExistence(timeout: 10))
        addButton.tap()
        
        let watchlistTab = app.tabBars.buttons["Watch list"]
        XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3))
        watchlistTab.tap()
        
        let filterButton = app.navigationBars.buttons.element(boundBy: 1)
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5), "Filter button should exist.")
        filterButton.tap()
        
        let tvShowsButton = app.cells.staticTexts["Tv Shows"]
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
