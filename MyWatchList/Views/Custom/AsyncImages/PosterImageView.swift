//
//  PosterImageView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 31/10/2025.
//

import SwiftUI

struct PosterImageView: View {
    @Environment(\.networkManager) var networkManager
    
    let path: String
    let shape: PosterShape
    let size: PosterSize
    let contentMode: ContentMode
    
    enum PosterShape {
        case rounded(radius: CGFloat)
        case circle
    }
    
    enum PosterSize {
        case fixed(width: CGFloat, height: CGFloat)
        case flexible(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, minHeight: CGFloat? = nil)
    }
    
    init(path: String, shape: PosterShape = .rounded(radius: 20), size: PosterSize = .flexible(), contentMode: ContentMode = .fit) {
        self.path = path
        self.shape = shape
        self.size = size
        self.contentMode = contentMode
    }
    
    
    var body: some View {
        AsyncImage(url: networkManager.imageURL.appending(path: path)) { image in
            image
                .resizable()
                .modifier(SizeModifier(size: size))
                .aspectRatio(contentMode: contentMode)
                .modifier(ShapeModifier(shape: shape))
                .shadow(color: .white, radius: 3)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    PosterImageView(path: "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg")
}
