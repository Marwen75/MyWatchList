//
//  Extension-EnvironmentValues.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

extension EnvironmentValues {
    var networkManager: NetworkManager {
        get { self[NetworkManagerKey.self] }
        set { self[NetworkManagerKey.self] = newValue }
    }
}
