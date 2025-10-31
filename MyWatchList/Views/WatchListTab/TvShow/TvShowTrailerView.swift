//
//  TvShowTrailerView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI
import YouTubePlayerKit

struct TvShowTrailerView: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
#if os(iOS)
        YouTubePlayerView(YouTubePlayer(urlString: "\(networkManager.videoUrl)" + "\(tvShow.showTrailer)"))
            .frame(idealWidth: 300, idealHeight: 250)
            .cornerRadius(20)
            .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
        
#else
YouTubePlayerView(YouTubePlayer(urlString: "\(networkManager.videoUrl)" + "\(tvShow.showTrailer)"))
    .frame(minWidth: 350, minHeight: 300)
    .cornerRadius(20)
    .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
#endif
    }
}

#Preview {
    TvShowTrailerView(tvShow: .example)
}
