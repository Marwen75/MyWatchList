//
//  SmallPosterImageView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 12/10/2025.
//

import SwiftUI

struct SmallPosterImageView: View {
    @Environment(\.networkManager) var networkManager
    
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    let path: String
    
    var body: some View {
        AsyncImage(url: networkManager.imageURL.appending(path: path)) { poster in
            poster
                .resizable()
                .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                .scaledToFit()
                .cornerRadius(20)
                .background {
                    RoundedRectangle(cornerRadius: 20).stroke(Color.yellow.mix(with: .black, by: 0.3), lineWidth: 1)
                }
                .shadow(color: Color.white, radius: 3)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    SmallPosterImageView(maxWidth: 100, maxHeight: 100, path: "")
}
