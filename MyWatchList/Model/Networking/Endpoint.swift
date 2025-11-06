//
//  Endpoint.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct Endpoint<Response: Decodable> {
    var path: String
    var method = HTTPMethod.get
    var pathComponents: [String]
    let queryItems: [URLQueryItem]
    
    init(path: String, method: HTTPMethod = HTTPMethod.get, pathComponents: [String] = [], queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.pathComponents = pathComponents
        
        var combinedItems = queryItems
        combinedItems.append(URLQueryItem(name: "language", value: Locale.appLanguageCode))
        self.queryItems = combinedItems
    }
}

extension Endpoint where Response == TmdbContent {
    static func movieDetails(id: String, includeCredits: Bool = false) -> Self {
        var components = [id]
        if includeCredits { components.append("credits") }
        let queryItems = [URLQueryItem(name: "append_to_response", value: "videos")]
        
        return Endpoint(path: "movie", pathComponents: components, queryItems: queryItems)
    }
    
    static func tvShowDetails(id: String, includeCredits: Bool = false) -> Self {
        var components = [id]
        if includeCredits { components.append("credits") }
        let queryItems = [URLQueryItem(name: "append_to_response", value: "videos")]
        
        return Endpoint(path: "tv", pathComponents: components, queryItems: queryItems)
    }
}

extension Endpoint where Response == TmdbResult {
    static func movies(query: String, page: Int = 1) -> Self {
        Endpoint(path: "search/movie", queryItems: [URLQueryItem(name: "query", value: query), URLQueryItem(name: "page", value: "\(page)")])
    }

    static func shows(query: String, page: Int = 1) -> Self {
        Endpoint(path: "search/tv",queryItems: [URLQueryItem(name: "query", value: query), URLQueryItem(name: "page", value: "\(page)")])
    }
}

extension Endpoint where Response == Credits {
    static func movieCredits(id: String) -> Self {
        Endpoint(path: "movie", pathComponents: [id, "credits"])
    }

    static func showCredits(id: String) -> Self {
        Endpoint(path: "tv", pathComponents: [id, "credits"])
    }
}

extension Endpoint where Response == Season {
    static func seasonDetails(showId: String, seasonNumber: Int) -> Self {
        Endpoint(path: "tv", pathComponents: [showId, "season", "\(seasonNumber)"])
    }
}
