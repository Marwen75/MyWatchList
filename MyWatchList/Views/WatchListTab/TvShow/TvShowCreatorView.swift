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
                    PersonImageView(width: 50, height: 50, profilePath: director.directorPicture)
                    
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
