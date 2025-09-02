//
//  Tag-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }
    
    var tagName: String {
        name ?? ""
    }
    
    var tagContents: [Content] {
        let arrayOfContents = contents?.allObjects as? [Content] ?? []
        return arrayOfContents.sorted { $0.priority > $1.priority }
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.lowercased()
        let right = rhs.tagName.lowercased()
        
        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
