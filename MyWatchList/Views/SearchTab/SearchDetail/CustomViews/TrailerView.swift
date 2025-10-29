//
//  TrailerView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/09/2025.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        if let tmdbContent = searchDetailViewModel.tmdbContent, let videos = tmdbContent.videos, let video = videos.results.first(where: {$0.type == "Trailer"}) {
#if os(iOS)
            YouTubePlayerView(YouTubePlayer(urlString: "\(searchDetailViewModel.videoUrl)" + video.key))
                .frame(idealWidth: 300, idealHeight: 250)
                .cornerRadius(20)
                .shadow(color: Color.yellow.mix(with: .black, by: 0.1).opacity(0.5), radius: 5)
#else
            YouTubePlayerView(YouTubePlayer(urlString: "\(searchDetailViewModel.videoUrl)" + video.key))
                .frame(maxWidth: 700, minHeight: 300)
                .cornerRadius(20)
                .shadow(color: Color.yellow.mix(with: .black, by: 0.1).opacity(0.5), radius: 5)
#endif
        }
    }
}

#Preview {
    TrailerView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
