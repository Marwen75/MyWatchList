//
//  TvShowPosterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowPosterView: View {
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        PosterImageView(path: tvShow.showPoster, size: .flexible(maxHeight: 650))
    }
}

#Preview {
    TvShowPosterView(tvShow: .example)
}
