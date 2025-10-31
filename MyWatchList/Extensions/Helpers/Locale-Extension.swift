//
//  Locale-Extension.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 31/10/2025.
//

import Foundation

extension Locale {
    static var appLanguageCode: String {
        Locale.preferredLanguages.first?.prefix(2).description ?? "en"
    }
}
