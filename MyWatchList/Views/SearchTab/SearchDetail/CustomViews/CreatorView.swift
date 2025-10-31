//
//  CreatorView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/09/2025.
//

import SwiftUI

struct CreatorView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(searchDetailViewModel.creators) { creator in
                    if let profilePath = creator.profilePath {
                        PosterImageView(path: profilePath, shape: .circle, size: .fixed(width: 50, height: 50), contentMode: .fill)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                            }
                            .opacity(0.8)
                            .shadow(color: .white, radius: 1)
                    }
                    Text(creator.name ?? "")
                        .infoStyle()
                }
            }
        }
        .scrollDisabled(searchDetailViewModel.creators.count <= 1)
        .safeAreaPadding([.leading, .top, .bottom], 10)
    }
}

#Preview {
    CreatorView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
