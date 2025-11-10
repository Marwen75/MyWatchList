//
//  WatchPriority.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/11/2025.
//

import Foundation

enum WatchPriority: Int16, CaseIterable, Identifiable {
    case low = 0
    case medium = 1
    case high = 2

    var id: Int16 { rawValue }

    var displayName: String {
        switch self {
        case .low: return NSLocalizedString("Watch later", comment: "")
        case .medium: return NSLocalizedString("Must watch", comment: "")
        case .high: return NSLocalizedString("Watch urgently", comment: "")
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "eye.half.closed"
        case .medium: return "eye"
        case .high: return "eye.trianglebadge.exclamationmark"
        }
    }
}
