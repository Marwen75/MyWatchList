//
//  TvShowListRow.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

import SwiftUI

struct TvShowListRow: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var show: TvShow
    
    var body: some View {
        NavigationLink(value: WatchListRoute.tvShowDetails(tvShow: show)) {
            VStack {
                Text(show.showTitle)
                    .contentTitleStyle()
                
                Spacer()
                
                TvListRowPosterWithInfoView(tvShow: show)
                
                ProgressView("\(show.numberOfEpisodesWatched)/\(show.numberOfEpisodes) episodes watched.", value: show.showProgress)
                    .padding()
                    .infoStyle()
                    .tint(.yellow.mix(with: .black, by: 0.2))
            }
        } 
    }
}

#Preview {
    TvShowListRow(show: .example)
}
