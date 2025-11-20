//
//  Extension-View.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 14/11/2025.
//

import SwiftUI
import WidgetKit

extension View {
    @ViewBuilder
    func widgetBackground<BG: View>(@ViewBuilder _ background: () -> BG) -> some View {
        self.containerBackground(for: .widget, content: background)
    }
}
