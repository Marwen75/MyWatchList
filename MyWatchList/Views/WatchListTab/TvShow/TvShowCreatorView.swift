//
//  TvShowCreatorView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowCreatorView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(tvShow.showDirectors) { director in
                    PosterImageView(path: director.directorPicture, shape: .circle, size: .fixed(width: 50, height: 50), contentMode: .fill)
                    
                    Text(director.directorName)
                        .infoStyle()
                    
                    Spacer()
                }
            }
        }
        .scrollDisabled(tvShow.showDirectors.count <= 1)
        .safeAreaPadding([.top, .bottom], 10)
    }
}

#Preview {
    TvShowCreatorView(tvShow: .example)
}
