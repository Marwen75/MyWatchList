//
//  AppEnvironment.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct AppEnvironment {
    var name: String
    var baseURL: URL
    var session: URLSession
    
    static let production = AppEnvironment(
        name: "Production",
        baseURL: URL(string: "https://imdb.iamidiotareyoutoo.com/")!,
        session: {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = [
                "APIKey": "production-key-from-keychain"
            ]
            return URLSession(configuration: configuration)
        }()
    )
    
    #if DEBUG
    static let testing = AppEnvironment(
        name: "Testing",
        baseURL: URL(string: "https://imdb.iamidiotareyoutoo.com/")!,
        session: {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.httpAdditionalHeaders = [
                "APIKey": "test-key"
            ]
            return URLSession(configuration: configuration)
        }()
    )
    #endif
}
