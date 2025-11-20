//
//  MockFileManager.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import Foundation
@testable import MyWatchList

final class MockFileManager: FileManaging {
    var files: [String: Data] = [:]
    var containerURLToReturn: URL? = URL(fileURLWithPath: "/mock-root")
    
    func fileExists(atPath path: String) -> Bool {
        files[path] != nil
    }
    
    func containerURL(forSecurityApplicationGroupIdentifier identifier: String) -> URL? {
        containerURLToReturn
    }
    
    func writeFile(data: Data, to url: URL) throws {
        files[url.path] = data
    }
    
    func removeItem(at url: URL) throws {
        files[url.path] = nil
    }
    
    func contents(atPath path: String) -> Data? {
        files[path]
    }
}
