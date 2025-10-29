//
//  PersonImageView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 12/10/2025.
//

import SwiftUI

struct PersonImageView: View {
    @Environment(\.networkManager) var networkManager
    let width: CGFloat
    let height: CGFloat
    let profilePath: String
    
    var body: some View {
        AsyncImage(url: networkManager.imageURL.appending(path: profilePath)) { image in
            image
                .resizable()
                .frame(width: width, height: height)
                .scaledToFill()
                .clipShape(.circle)
                .background {
                    Circle().stroke(Color.yellow.mix(with: .black, by: 0.3), lineWidth: 1)
                }
                .shadow(color: .white, radius: 3)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    PersonImageView(width: 100, height: 100, profilePath: "")
}
