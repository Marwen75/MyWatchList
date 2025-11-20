//
//  EmptyWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI

struct EmptyWidgetView: View {
    var body: some View {
        VStack {
            Image(systemName: "film.stack")
                .font(.system(size: 36))
                .foregroundStyle(.gray)
            Text("Your watchlist is empty")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .widgetBackground {
            LinearGradient(colors: [.black, .darkRed.opacity(0.9)],startPoint: .top, endPoint: .bottom)
        }
    }
}
