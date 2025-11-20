//
//  MyWatchListWidgetBundle.swift
//  MyWatchListWidget
//
//  Created by Marwen Haouacine on 13/11/2025.
//

import WidgetKit
import SwiftUI

@main
struct MyWatchListWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWatchListMovieWidget()
        MyWatchListShowWidget()
    }
}
