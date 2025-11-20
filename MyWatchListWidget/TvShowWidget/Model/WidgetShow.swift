//
//  WidgetShow.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct WidgetShow: Identifiable {
    let objectID: NSManagedObjectID
    let id: String
    let title: String
    let seasonNumber: Int
    let episodeNumber: Int
    let episodeTitle: String
    let progress: Double
    let image: UIImage?
}
