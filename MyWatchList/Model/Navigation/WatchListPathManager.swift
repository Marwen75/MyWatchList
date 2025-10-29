//
//  WatchListPathManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 02/10/2025.
//

import SwiftUI

class WatchListPathManager: ObservableObject {
    @Published var routes: [WatchListRoute] = []
    
    func push(to screen: WatchListRoute) {
        routes.append(screen)
    }
    
    func pop() {
        routes.removeLast()
    }
    
    func reset() {
        routes = []
    }
}
