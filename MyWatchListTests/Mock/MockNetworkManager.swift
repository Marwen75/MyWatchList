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
    var mockError: URLError.Code = .badServerResponse
    
    init(fileName: JsonResponse, shouldFail: Bool = false, mockError: URLError.Code = .badServerResponse) {
            self.fileName = fileName
            self.shouldFail = shouldFail
            self.mockError = mockError
    }
    
    
    func fetch<T>(_ resource: MyWatchList.Endpoint<T>, parameters queryParameters: [URLQueryItem]?, contentId id: String?, withCredits: Bool, withSeasonDetails: Bool, seasonNumber: Int?) async throws -> T where T : Decodable {
        if shouldFail {
            throw URLError(mockError)
        }
        
        guard let url = #bundle.url(forResource: fileName.rawValue, withExtension: "json") else { throw URLError(.fileDoesNotExist) }
        
        let data = try Data(contentsOf: url)
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            
            return decodedObject
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value {
        environment[keyPath: keyPath]
    }
}
