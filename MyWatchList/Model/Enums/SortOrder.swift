//
//  SortOrder.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 11/11/2025.
//

import Foundation

enum SortOrder: String, CaseIterable, Identifiable {
    case priority, title
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .priority: NSLocalizedString("By Priority", comment: "")
        case .title: NSLocalizedString("By Title", comment: "")
        }
    }
}
