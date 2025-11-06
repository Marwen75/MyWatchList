//
//  ErrorManagerTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import XCTest
@testable import MyWatchList

@MainActor
final class ErrorManagerTests: MyWatchListBaseTestCase {
    var errorManager: ErrorManager!
    
    override func setUp() {
        super.setUp()
        errorManager = ErrorManager()
    }
    
    override func tearDown() {
        errorManager = nil
        super.tearDown()
    }
    
    // MARK: - Present (generic errors)
    
    func testPresentWithNetworkFailedSetsGenericAlert() {
        let error = AppError.networkFailed
        
        errorManager.present(error)
        
        guard let context = errorManager.alertContext else {
            return XCTFail("Expected alertContext to be set")
        }
        
        XCTAssertTrue(context.title.contains("Oups"), "Expected localized 'Oups' title, got: \(context.title)")
        
        let message = context.message
        XCTAssertTrue(message.contains("Impossible") || message.contains("Unable"), "Expected network-related message, got: \(message)")
        
        XCTAssertNil(context.primaryAction, "Expected no custom action for network errors")
        XCTAssertEqual(context.primaryButtonTitle, "Ok")
    }
    
    func testPresentWithInvalidRequestSetsGenericAlert() {
        errorManager.present(.invalidRequest)
        
        guard let context = errorManager.alertContext else {
            return XCTFail("Expected alertContext to be set")
        }
        
        XCTAssertTrue(context.message.contains("requête") || context.message.contains("request"), "Expected invalid request message, got: \(context.message)")
        
        XCTAssertNil(context.primaryAction)
        XCTAssertEqual(context.primaryButtonTitle, "Ok")
    }
    
    // MARK: - Present (permission error)
    
    func testPresentWithPermissionDeniedSetsSettingsAction() {
        errorManager.present(.permissionDenied)
        
        guard let context = errorManager.alertContext else {
            return XCTFail("Expected alertContext to be set for permissionDenied")
        }
        
        XCTAssertTrue(context.title.contains("Oups"), "Expected title, got: \(context.title)")
        
        XCTAssertTrue(context.message.contains("settings") || context.message.contains("réglages"), "Expected message guiding user to settings, got: \(context.message)")
        
        XCTAssertTrue(context.primaryButtonTitle.contains("Settings") || context.primaryButtonTitle.contains("réglages"))
        XCTAssertNotNil(context.primaryAction)
    }
    
    // MARK: - Dismiss
    
    func testDismissResetsAlertContext() {
        errorManager.present(.networkFailed)
        XCTAssertNotNil(errorManager.alertContext)
        
        errorManager.dismiss()
        
        XCTAssertNil(errorManager.alertContext, "Expected alertContext to be nil after dismiss")
    }
    
    // MARK: - Multiple errors
    
    func testPresentReplacesPreviousError() {
        errorManager.present(.networkFailed)
        let firstContext = errorManager.alertContext
        
        errorManager.present(.invalidRequest)
        
        XCTAssertNotNil(errorManager.alertContext)
        XCTAssertNotEqual(errorManager.alertContext?.message, firstContext?.message)
    }
}
