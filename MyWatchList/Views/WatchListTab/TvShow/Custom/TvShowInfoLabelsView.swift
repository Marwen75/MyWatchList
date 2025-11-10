//
//  TvShowInfoLabelsView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import SwiftUI

struct TvShowInfoLabelsView: View {
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Label("\(tvShow.showFirstAirDate)", systemImage: "calendar")
                Spacer()
                if tvShow.showInProduction {
                    Label("In production", systemImage: "video")
                } else {
                    Label(tvShow.showLastAirDate, systemImage: "video.slash")
                }
            }
            
            HStack {
                Label("\(tvShow.showNumberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
                Spacer()
                Label(tvShow.showVoteAverage == "0" ? "N/A" : tvShow.showVoteAverage + "/10", systemImage: "star.circle")
            }
        }
        .infoStyle()
    }
}

#Preview {
    TvShowInfoLabelsView(tvShow: .example)
}
