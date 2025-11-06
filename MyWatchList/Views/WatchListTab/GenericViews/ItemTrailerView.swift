//
//  ItemTrailerView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI
import YouTubePlayerKit

/// A generic trailer player view for any WatchableItem
struct ItemTrailerView<T: WatchableItem>: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var item: T
    
    var body: some View {
#if os(iOS)
        YouTubePlayerView(
            YouTubePlayer(urlString: "\(networkManager.videoUrl)\(item.trailerPath)")
        )
        .frame(idealWidth: 300, idealHeight: 250)
        .cornerRadius(20)
        .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
#else
        YouTubePlayerView(
            YouTubePlayer(urlString: "\(networkManager.videoUrl)\(item.trailerPath)")
        )
        .frame(minWidth: 350, minHeight: 300)
        .cornerRadius(20)
        .shadow(color: Color.darkYellow.opacity(0.5), radius: 5)
#endif
    }
}

#Preview {
    ItemTrailerView(item: Movie.example)
}
