//
//  NetworkManagerProtocol.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 06/11/2025.
//

import Foundation

/// The protocol approach lets us create mocks for testing or replace the network manager in production without to much cost
@dynamicMemberLookup
protocol NetworkManagerProtocol {
    func fetch<T>(_ resource: Endpoint<T>) async throws -> T
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppEnvironment, Value>) -> Value { get }
}
