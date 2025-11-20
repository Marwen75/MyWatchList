//
//  FileManaging.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import Foundation

/// Abstraction over FileManager to allow injecting a mock in tests.
protocol FileManaging {
    func fileExists(atPath path: String) -> Bool
    func containerURL(forSecurityApplicationGroupIdentifier identifier: String) -> URL?
    func removeItem(at url: URL) throws
    func contents(atPath path: String) -> Data?
    func writeFile(data: Data, to url: URL) throws
}

extension FileManager: FileManaging {
    func writeFile(data: Data, to url: URL) throws {
        try data.write(to: url)
    }
}
