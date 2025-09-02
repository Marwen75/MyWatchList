//
//  HTTPMethod.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import Foundation

enum HTTPMethod: String {
    case delete, get, patch, post, put

    var rawValue: String {
        String(describing: self).uppercased()
    }
}
