//
//  WidgetMovie.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct WidgetMovie: Identifiable {
    let objectID: NSManagedObjectID
    let id: String
    let title: String
    let tags: String
    let image: UIImage?
}
