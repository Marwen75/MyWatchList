//
//  CastView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/09/2025.
//

import SwiftUI

struct CastView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(searchDetailViewModel.castMembers) { actor in
                    VStack {
                        if let profilePath = actor.profilePath {
                            PosterImageView(path: profilePath, shape: .circle, size: .fixed(width: 100, height: 100), contentMode: .fill)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .background {
                                    Circle().stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                                }
                                .shadow(color: .white, radius: 3)
                        }
                        Text(actor.name)
                            .overviewStyle()
                    }
                }
            }
        }
        .safeAreaPadding([.leading, .top, .trailing], 10)
    }
}

#Preview {
    CastView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
