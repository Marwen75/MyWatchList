//
//  MediumMovieWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct MediumMovieWidgetView: View {
    let movie: WidgetMovie
    
    var body: some View {
        Link(destination: movie.objectID.uriRepresentation()) {
            HStack(spacing: 10) {
                if let image = movie.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 140)
                        .cornerRadius(12)
                        .shadow(color: .darkRed.opacity(0.8), radius: 20, x: 0, y: 0)
                        .shadow(radius: 8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .shadow(radius: 3)
                        .lineLimit(2)
                    
                    Text(movie.tags)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(3)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .widgetBackground { BackgroundBlurredImage(image: movie.image) }
        }
    }
}
