//
//  Array-Extension.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/10/2025.
//

import Foundation

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
