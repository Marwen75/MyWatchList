//
//  ListRowPosterImageView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 12/10/2025.
//

import SwiftUI

struct ListRowPosterImageView: View {
    @Environment(\.networkManager) var networkManager
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let path: String
    
    var body: some View {
        AsyncImage(url: networkManager.imageURL.appending(path: path)) { poster in
            poster
                .resizable()
                .frame(minHeight: minHeight, maxHeight: maxHeight)
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
    ListRowPosterImageView(minHeight: 150, maxHeight: 300, path: "")
}
