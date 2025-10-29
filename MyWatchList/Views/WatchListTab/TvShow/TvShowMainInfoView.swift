//
//  TvShowMainInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowMainInfoView: View {
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
#if os(iOS)
        VStack(alignment: .leading) {
            Label(tvShow.showDirectors.count > 1 ? "Creators" : "Creator", systemImage: "person.crop.square.badge.video")
            
            TvShowCreatorView(tvShow: tvShow)
        }
        .infoStyle()
        
        HStack {
            Label("\(tvShow.showFirstAirDate)", systemImage: "calendar")
            
            Spacer()
            
            if tvShow.showInProduction {
                Label("In production", systemImage: "video")
            } else {
                Label(tvShow.showLastAirDate, systemImage: "video.slash")
            }
        }
        .infoStyle()
        
        HStack {
            Label("\(tvShow.showNumberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
            
            Spacer()
            
            Label(tvShow.showVoteAverage == "0" ? "N/A" : tvShow.showVoteAverage + "/10", systemImage: "star.circle")
        }
        .infoStyle()
        
        HStack {
            Text(tvShow.showGenres)
        }
        .infoStyle()
        
        Text(tvShow.showOverview)
            .overviewStyle()
        
#else
        VStack(alignment: .leading) {
            CustomDivider()
            
            Label(tvShow.showDirectors.count > 1 ? "Creators" : "Creator", systemImage: "person.crop.square.badge.video")
            
            TvShowCreatorView(tvShow: tvShow)
            
            VStack(spacing: 10) {
                CustomDivider()
                
                HStack {
                    Label("\(tvShow.showFirstAirDate)", systemImage: "calendar")
                    
                    Spacer()
                    
                    if tvShow.showInProduction {
                        Label("In production", systemImage: "video")
                    } else {
                        Label(tvShow.showLastAirDate, systemImage: "video.slash")
                    }
                }
                
                CustomDivider()
                
                HStack {
                    Label("\(tvShow.showNumberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
                    
                    Spacer()
                    
                    Label(tvShow.showVoteAverage == "0" ? "N/A" : tvShow.showVoteAverage + "/10", systemImage: "star.circle")
                }
                
                CustomDivider()
                
                Text(tvShow.showGenres)
                
                CustomDivider()
                
                Text(tvShow.showOverview)
                
                CustomDivider()
            }
            
            Spacer()
            
            TvShowPriorityAndTagView(tvShow: tvShow)
        }
        .infoStyle()
#endif
    }
}

#Preview {
    TvShowMainInfoView(tvShow: .example)
}
