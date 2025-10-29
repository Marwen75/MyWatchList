//
//  SearchPathManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 02/10/2025.
//

import SwiftUI

class SearchPathManager: ObservableObject {
    @Published var routes: [SearchRoute] = []
    
    func push(to screen: SearchRoute) {
        routes.append(screen)
    }
    
    func pop() {
        routes.removeLast()
    }
    
    func reset() {
        routes = []
    }
}
