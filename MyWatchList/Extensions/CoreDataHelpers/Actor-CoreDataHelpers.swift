//
//  Actor-CoreDataHelpers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

import SwiftUI

extension Actor {
    var actorId: Int {
        Int(id)
    }
    
    var actorName: String {
        name ?? ""
    }
    
    var actorPicture: String {
        picture ?? ""
    }
}
