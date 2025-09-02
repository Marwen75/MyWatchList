//
//  Endpoint.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

struct Endpoint<T: Decodable> {
    var path: String
    var type: T.Type
    var method = HTTPMethod.get
    var headers = [String: String]()
}

extension Endpoint where T == ImdbResult {
    static let imdbResult = Endpoint(path: "search", type: ImdbResult.self, headers: ["Accept": "*/*"])
}

extension Endpoint where T == JustWatchResult {
    static let justWatchResult = Endpoint(path: "justwatch", type: JustWatchResult.self, headers: ["Accept": "*/*"])
}
