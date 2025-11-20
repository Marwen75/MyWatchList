//
//  MediumShowWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct MediumShowWidgetView: View {
    let show: WidgetShow
    
    var body: some View {
        Link(destination: show.objectID.uriRepresentation()) {
            HStack(spacing: 12) {
                if let img = show.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 150)
                        .cornerRadius(12)
                        .shadow(color: .darkRed.opacity(0.8), radius: 18)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(show.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    
                    Text("S\(show.seasonNumber) • E\(show.episodeNumber) — \(show.episodeTitle)")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)
                    
                    ProgressView(value: show.progress)
                        .progressViewStyle(.linear)
                        .tint(.yellow)
                }
                Spacer()
            }
            .padding()
            .widgetBackground { BackgroundBlurredImage(image: show.image) }
        }
    }
}
