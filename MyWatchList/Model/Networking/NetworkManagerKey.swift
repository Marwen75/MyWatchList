//
//  NetworkManagerKey.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

struct NetworkManagerKey: EnvironmentKey {
    static var defaultValue = NetworkManager(environment: .testing)
}
