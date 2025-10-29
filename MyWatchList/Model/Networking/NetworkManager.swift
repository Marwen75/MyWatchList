//
//  NetworkManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

/// The protocol approach lets us create mocks for testing or replace the network manager in production without to much cost
@dynamicMemberLookup
protocol NetworkManagerProtocol {
    func fetch<T>(_ resource: Endpoint<T>, parameters queryParameters: [URLQueryItem]?, contentId id: String?, withCredits: Bool, withSeasonDetails: Bool, seasonNumber: Int?) async throws -> T
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value { get }
}

@dynamicMemberLookup
struct NetworkManager: NetworkManagerProtocol {
    var environment: AppEnvironment
    
    /// Fetches in a generic way the data from the network
    /// - Parameters:
    ///   - resource: The endpoint to target for the fetching
    ///   - queryParameters: The parameters to add to the request
    ///   - id: The optional id if the request needs it
    ///   - withCredits: True if the request should include credits
    ///   - withSeasonDetails: True if the request should include season details
    ///   - seasonNumber: The season number to fetch
    /// - Returns: A decoded result from the request
    @MainActor
    func fetch<T>(_ resource: Endpoint<T>, parameters queryParameters: [URLQueryItem]? = nil, contentId id: String? = nil, withCredits: Bool = false, withSeasonDetails: Bool = false, seasonNumber: Int? = nil) async throws -> T {
        
        var url = URL(string: resource.path, relativeTo: environment.baseURL)
        if let queryItems = queryParameters {
            url?.append(queryItems: queryItems)
        }
        
        if let id {
            url = url?.appending(path: id)
            if withCredits {
                url = url?.appending(path: "credits")
            }
            if withSeasonDetails {
                url = url?.appending(path: "season/" + "\(seasonNumber, default: "")", directoryHint: .notDirectory)
            }
        }
        
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = resource.method.rawValue
            
            let (data, response) = try await environment.session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            do {
                let decoder = JSONDecoder()
                
                return try decoder.decode(T.self, from: data)
            } catch {
                throw URLError(.cannotDecodeRawData)
            }
        } else {
            throw URLError(.unsupportedURL)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value {
        environment[keyPath: keyPath]
    }
}
