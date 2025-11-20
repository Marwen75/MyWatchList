//
//  SmallShowWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct SmallShowWidgetView: View {
    let show: WidgetShow
    
    var body: some View {
        Link(destination: show.objectID.uriRepresentation()) {
            VStack(spacing: 6) {
                if let img = show.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(color: .darkRed.opacity(0.8), radius: 12)
                        .padding(.horizontal, 10)
                }
                
                Text(show.title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text("S\(show.seasonNumber) • E\(show.episodeNumber)")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.bottom, 4)
            .widgetBackground { BackgroundBlurredImage(image: show.image) }
        }
    }
}
