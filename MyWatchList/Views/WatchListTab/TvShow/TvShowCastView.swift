//
//  TvShowCastView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowCastView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(tvShow.showActors) { actor in
                    VStack {
                        if actor.actorPicture != "" {
                            PosterImageView(path: actor.actorPicture, shape: .circle, size: .fixed(width: 100, height: 100), contentMode: .fill)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .background {
                                    Circle().stroke(Color.darkYellow, lineWidth: 1)
                                }
                                .shadow(color: .white, radius: 3)
                        }
                        Text(actor.actorName)
                            .infoStyle()
                    }
                }
            }
        }
        .safeAreaPadding([.leading, .top, .trailing], 10)
    }
}

#Preview {
    TvShowCastView(tvShow: .example)
}
