//
//  MockNetworkManager.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 14/10/2025.
//

import Foundation
@testable import MyWatchList

struct MockNetworkManager: NetworkManagerProtocol {
    var environment: MyWatchList.AppEnvironment = .testing
    var fileName: JsonResponse
    var shouldFail: Bool = false
    var mockError: AppError = .networkFailed
    
    init(fileName: JsonResponse, shouldFail: Bool = false, mockError: AppError = .networkFailed) {
            self.fileName = fileName
            self.shouldFail = shouldFail
            self.mockError = mockError
    }
    
    func fetch<T>(_ resource: MyWatchList.Endpoint<T>) async throws -> T where T : Decodable {
        if shouldFail {
            throw mockError
        }
        
        guard let url = #bundle.url(forResource: fileName.rawValue, withExtension: "json") else { throw AppError.invalidURL }
        
        let data = try Data(contentsOf: url)
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            
            return decodedObject
        } catch {
            throw AppError(error)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value {
        environment[keyPath: keyPath]
    }
}
