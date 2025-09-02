//
//  NetworkManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct NetworkManager {
    var environment: AppEnvironment
    
    func fetch<T>(_ resource: Endpoint<T>, with data: Data? = nil, and queryParameters: [URLQueryItem]? = nil) async throws -> T {
        
        var url = URL(string: resource.path, relativeTo: environment.baseURL)
        if let queryItems = queryParameters {
            url?.append(queryItems: queryItems)
        }
        
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = resource.method.rawValue
            request.httpBody = data
            request.allHTTPHeaderFields = resource.headers
            
            let (data, response) = try await environment.session.data(for: request)
            
            print(response.url?.absoluteString ?? "No URL")
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } else {
            throw URLError(.unsupportedURL)
        }
    }
}
