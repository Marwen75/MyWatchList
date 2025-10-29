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
        BigPosterImageView(maxHeight: 650, path: tvShow.showPoster)
    }
}

#Preview {
    TvShowPosterView(tvShow: .example)
}
