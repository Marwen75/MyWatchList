//
//  Director-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 22/09/2025.
//

import SwiftUI

extension Director {
    var directorId: Int {
        Int(id)
    }
    
    var directorName: String {
        name ?? ""
    }
    
    var directorPicture: String {
        picture ?? ""
    }
}
