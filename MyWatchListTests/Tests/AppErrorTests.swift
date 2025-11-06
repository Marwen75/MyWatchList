//
//  AppErrorTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import XCTest
@testable import MyWatchList

final class AppErrorTests: MyWatchListBaseTestCase {
    func testNetworkFailedHasCorrectDescription() {
        let error = AppError.networkFailed
        let description = error.errorDescription ?? ""
        
        XCTAssertTrue(description.contains("Impossible") || description.contains("Unable"), "Expected localized message for network failure, got: \(description)")
    }
    
    func testDecodingErrorIsMappedCorrectly() {
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Corrupted"))
        let appError = AppError(decodingError)
        XCTAssertEqual(appError, .decodingFailed, "Expected decodingFailed AppError for DecodingError")
        
        let description = appError.errorDescription ?? ""
        XCTAssertFalse(description.isEmpty, "Error description should not be empty for decodingFailed")
    }
    
    func testDatabaseFailedHasCorrectDescription() {
        let error = AppError.databaseFailed
        let description = error.errorDescription ?? ""
        
        XCTAssertTrue(description.contains("access") || description.contains("accès"), "Expected localized message for database error, got: \(description)")
    }
    
    func testURLErrorIsMappedToNetworkFailed() {
        let urlError = URLError(.notConnectedToInternet)
        let appError = AppError(urlError)
        XCTAssertEqual(appError, .networkFailed, "Expected networkFailed for URLError")
        
        let description = appError.errorDescription ?? ""
        XCTAssertTrue(description.contains("Impossible") || description.contains("Unable"),"Expected localized message for network failure, got: \(description)")
    }
    
    func testPermissionDeniedHasCorrectDescription() {
        let error = AppError.permissionDenied
        let description = error.errorDescription ?? ""
        
        XCTAssertTrue(description.contains("Permission"), "Expected localized message for permission denied, got: \(description)")
    }
    
    func testInvalidRequestHasProperDescription() {
        let error = AppError.invalidRequest
        let description = error.errorDescription ?? ""
        
        XCTAssertTrue(description.contains("request") || description.contains("requête"), "Expected localized message for invalid request, got: \(description)")
    }
    
    func testInvalidURLHasProperDescription() {
        let error = AppError.invalidURL
        let description = error.errorDescription ?? ""
        
        XCTAssertTrue(description.contains("URL"), "Expected message mentioning URL, got: \(description)")
    }
    
    func testDebugDescriptionForKnownError() {
        let error = AppError.invalidURL
        XCTAssertTrue(
            error.debugDescription.contains("invalidURL"),
            "Expected debugDescription to include case name, got: \(error.debugDescription)"
        )
    }
    
    func testUnknownErrorIsWrappedProperly() {
        let nsError = NSError(domain: "test", code: 1)
        let appError = AppError(nsError)
        
        switch appError {
        case .unknown(let underlying):
            XCTAssertEqual((underlying as NSError).domain, "test")
        default:
            XCTFail("Expected unknown error, got \(appError)")
        }
        
        let description = appError.errorDescription ?? ""
        let debugDescription = appError.debugDescription
        XCTAssertTrue(description.contains("erreur") || description.contains("error"), "Expected generic unexpected error message, got: \(description)")
        XCTAssertTrue(debugDescription.contains("Unknown error"), "Expected generic unexpected error message, got: \(debugDescription)")
    }
}
