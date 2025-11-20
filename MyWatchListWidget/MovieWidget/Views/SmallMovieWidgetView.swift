//
//  SmallMovieWidgetView.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI
import CoreData

struct SmallMovieWidgetView: View {
    let movie: WidgetMovie
    
    var body: some View {
        Link(destination: movie.objectID.uriRepresentation()) {
            VStack {
                if let image = movie.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(color: .darkRed.opacity(0.8), radius: 15, x: 0, y: 0)
                        .shadow(radius: 10)
                        .padding(.horizontal, 10)
                        .frame(maxHeight: 190)
                }
            }
            .padding(.bottom, 3)
            .widgetBackground { BackgroundBlurredImage(image: movie.image) }
        }
    }
}
