//
//  LargeMovieWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct LargeMovieWidgetView: View {
    let movies: [WidgetMovie]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(movies.prefix(2)) { movie in
                Link(destination: movie.objectID.uriRepresentation()) {
                    VStack(spacing: 8) {
                        if let image = movie.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(12)
                                .shadow(color: .darkRed.opacity(0.7), radius: 20)
                                .shadow(radius: 10)
                        }
                        
                        Text(movie.title)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .shadow(radius: 3)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .widgetBackground {
            if let img = movies.first?.image {
                BackgroundBlurredImage(image: img)
            }
        }
    }
}
