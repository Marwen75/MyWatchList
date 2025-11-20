//
//  BackgroundBlurredImage.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import SwiftUI

struct BackgroundBlurredImage: View {
    let image: UIImage?
    
    var body: some View {
        if let img = image {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
                .blur(radius: 20)
                .overlay(Color.black.opacity(0.45))
                .ignoresSafeArea()
        } else {
            LinearGradient(colors: [.black, .darkRed.opacity(0.9)], startPoint: .top, endPoint: .bottom)
        }
    }
}
