//
//  NetworkManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

@dynamicMemberLookup
struct NetworkManager: NetworkManagerProtocol {
    var environment: AppEnvironment
    
    /// Fetches in a generic way the data from the network
    /// - Parameters:
    ///   - resource: The endpoint to target for the fetching
    /// - Returns: A decoded result from the request
    @MainActor
    func fetch<T>(_ resource: Endpoint<T>) async throws -> T {
        var url = URL(string: resource.path, relativeTo: environment.baseURL)
        
        for component in resource.pathComponents {
            url = url?.appendingPathComponent(component)
        }
        
        url?.append(queryItems: resource.queryItems)
        
        guard let usableUrl = url else { throw AppError.invalidURL }
        
        var request = URLRequest(url: usableUrl)
        request.httpMethod = resource.method.rawValue
        
        print("➡️ URL:", url?.absoluteString ?? "nil")
        
        let (data, response) = try await environment.session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw AppError.invalidRequest
        }
        
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError(error)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value {
        environment[keyPath: keyPath]
    }
}
