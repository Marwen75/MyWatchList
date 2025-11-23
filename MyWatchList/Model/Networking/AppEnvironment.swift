//
//  AppEnvironment.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation
import ConfidentialKit

struct AppEnvironment {
    var name: String
    var baseURL: URL
    var imageURL: URL
    var videoUrl: URL
    var session: URLSession
    
    /// This is a portfolio app, in a real app the production api key should be on key chain, server sided etc
    static let production = AppEnvironment(
        name: "Production",
        baseURL: URL(string: "https://api.themoviedb.org/3/")!, imageURL: URL(string: "https://image.tmdb.org/t/p/w500/")!, videoUrl: URL(string: "https://youtube.com/watch?v=")!,
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
        baseURL: URL(string: "https://api.themoviedb.org/3/")!, imageURL: URL(string: "https://image.tmdb.org/t/p/w500/")!, videoUrl: URL(string: "https://youtube.com/watch?v=")!,
        session: {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.httpAdditionalHeaders = [
                "Authorization": "\(Secrets.$token)"
            ]
            return URLSession(configuration: configuration)
        }()
    )
#endif
}
