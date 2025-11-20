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
    let cacheIdentifier: String?
    
    enum PosterShape {
        case rounded(radius: CGFloat)
        case circle
    }
    
    enum PosterSize {
        case fixed(width: CGFloat, height: CGFloat)
        case flexible(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, minHeight: CGFloat? = nil)
    }
    
    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray.opacity(0.3))
            .overlay(Image(systemName: "film").foregroundStyle(.white.opacity(0.5)))
    }
    
    init(path: String, shape: PosterShape = .rounded(radius: 20), size: PosterSize = .flexible(), contentMode: ContentMode = .fit, cacheIdentifier: String? = nil) {
        self.path = path
        self.shape = shape
        self.size = size
        self.contentMode = contentMode
        self.cacheIdentifier = cacheIdentifier
    }
    
    var body: some View {
        AsyncImage(url: networkManager.imageURL.appending(path: path)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .modifier(SizeModifier(size: size))
                    .aspectRatio(contentMode: contentMode)
                    .modifier(ShapeModifier(shape: shape))
                    .shadow(color: .white, radius: 3)
                    .onAppear {
                        if let id = cacheIdentifier {
                            ImageCacheManager.saveImageToSharedContainer(image.asUIImage(), for: id)
                        }
                    }
            case .failure(_):
                placeholder
            case .empty:
                ProgressView()
            @unknown default:
                placeholder
            }
        }
    }
}

#Preview {
    PosterImageView(path: "/kiy8BHtIHAslh81rvFcZ4wbNGdY.jpg")
}
