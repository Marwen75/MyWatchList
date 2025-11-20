//
//  LargeShowWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct LargeShowWidgetView: View {
    let shows: [WidgetShow]
    
    var body: some View {
        VStack(spacing: 14) {
            ForEach(shows.prefix(2)) { show in
                Link(destination: show.objectID.uriRepresentation()) {
                    HStack(spacing: 12) {
                        if let img = show.image {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 140)
                                .cornerRadius(12)
                                .shadow(color: .darkRed.opacity(0.5), radius: 15)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(show.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Text("S\(show.seasonNumber) • E\(show.episodeNumber)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text(show.episodeTitle)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                                .lineLimit(2)
                            
                            ProgressView(value: show.progress)
                                .progressViewStyle(.linear)
                                .tint(.yellow)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .widgetBackground {
            if let img = shows.first?.image {
                BackgroundBlurredImage(image: img)
            }
        }
    }
}
